


-------------------------- Procedimientos Almacenados-----------------------


-- Procedimiento almacenado: Agregar un empleado
CREATE OR REPLACE PROCEDURE AgregarEmpleado(
    p_Nombre VARCHAR(50),
    p_Apellido VARCHAR(50),
    p_DepartamentoID INT,
    p_FechaContratacion DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Empleados (Nombre, Apellido, DepartamentoID, FechaContratacion)
    VALUES (p_Nombre, p_Apellido, p_DepartamentoID, p_FechaContratacion);
END;
$$;


-- Procedimiento almacenado: Actualizar horas asignadas a un empleado en un proyecto
CREATE OR REPLACE PROCEDURE ActualizarHorasEmpleadoProyecto(
    p_EmpleadoID INT,
    p_ProyectoID INT,
    p_HorasAsignadas INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE EmpleadosProyectos
    SET HorasAsignadas = p_HorasAsignadas
    WHERE EmpleadoID = p_EmpleadoID AND ProyectoID = p_ProyectoID;
END;
$$;


-------------------------- Funciones ---------------------------------

CREATE OR REPLACE FUNCTION ListarProyectosbyCliente(
    p_ClienteID INT
)
RETURNS TABLE (NombreProyecto VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT Proyectos.Nombre
    FROM Proyectos
    INNER JOIN ProyectosClientes ON Proyectos.ProyectoID = ProyectosClientes.ProyectoID
    WHERE ProyectosClientes.ClienteID = p_ClienteID;
END;
$$;



CREATE OR REPLACE FUNCTION ObtenerNombreCompleto(p_EmpleadoID INT)
RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS $$
DECLARE
    nombre_completo VARCHAR(100);
BEGIN
    SELECT Nombre || ' ' || Apellido
    INTO nombre_completo
    FROM Empleados
    WHERE EmpleadoID = p_EmpleadoID;

    RETURN nombre_completo;
END;
$$;



CREATE OR REPLACE FUNCTION ContarProyectosDeEmpleado(p_EmpleadoID INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total_proyectos INT;
BEGIN
    SELECT COUNT(*)
    INTO total_proyectos
    FROM EmpleadosProyectos
    WHERE EmpleadoID = p_EmpleadoID;

    RETURN total_proyectos;
END;
$$;


CREATE OR REPLACE FUNCTION ObtenerProyectosDeCliente(p_ClienteID INT)
RETURNS TABLE (ProyectoID INT, NombreProyecto VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT Proyectos.ProyectoID, Proyectos.Nombre
    FROM Proyectos
    INNER JOIN ProyectosClientes ON Proyectos.ProyectoID = ProyectosClientes.ProyectoID
    WHERE ProyectosClientes.ClienteID = p_ClienteID;
END;
$$;





CREATE OR REPLACE FUNCTION ObtenerTotalHorasPorProyecto(p_ProyectoID INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total_horas INT;
BEGIN
    SELECT COALESCE(SUM(HorasAsignadas), 0)
    INTO total_horas
    FROM EmpleadosProyectos
    WHERE ProyectoID = p_ProyectoID;

    RETURN total_horas;
END;
$$;


CREATE OR REPLACE FUNCTION EstaAsignadoAProyecto(p_EmpleadoID INT, p_ProyectoID INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    resultado BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM EmpleadosProyectos
        WHERE EmpleadoID = p_EmpleadoID AND ProyectoID = p_ProyectoID
    )
    INTO resultado;

    RETURN resultado;
END;
$$;

---------------------------------Trigger---------------------------------

-- Crear o reemplazar la función para registrar en la bitacora
CREATE OR REPLACE FUNCTION registrar_en_bitacora()
RETURNS TRIGGER AS $$
BEGIN
    -- Obtener el nombre de la tabla (empleados en este caso)
    DECLARE
        tabla_nombre VARCHAR(50);
        usuario_nombre VARCHAR(50);
    BEGIN
        -- Nombre de la tabla
        tabla_nombre := TG_TABLE_NAME;
        
        -- Obtener el nombre de usuario que ejecutó la operación
        usuario_nombre := CURRENT_USER;

        -- Verificar el tipo de operación que se está realizando
        IF (TG_OP = 'INSERT') THEN
            INSERT INTO Bitacora (Fecha, Tabla, Operacion, Usuario)
            VALUES (CURRENT_TIMESTAMP, tabla_nombre, 'INSERT', usuario_nombre);
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO Bitacora (Fecha, Tabla, Operacion, Usuario)
            VALUES (CURRENT_TIMESTAMP, tabla_nombre, 'UPDATE', usuario_nombre);
        ELSIF (TG_OP = 'DELETE') THEN
            INSERT INTO Bitacora (Fecha, Tabla, Operacion, Usuario)
            VALUES (CURRENT_TIMESTAMP, tabla_nombre, 'DELETE', usuario_nombre);
        END IF;

        -- Devolver NULL ya que no necesitamos afectar ninguna fila
        RETURN NULL;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_registrar_accion_empleado
AFTER INSERT OR UPDATE OR DELETE ON Empleados
FOR EACH ROW
EXECUTE FUNCTION registrar_en_bitacora();