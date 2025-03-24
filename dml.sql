-- Insertar datos en Departamentos
INSERT INTO Departamentos (Nombre) VALUES 
('Recursos Humanos'), 
('Desarrollo de Software'), 
('Soporte Técnico');

-- Insertar datos en Empleados
INSERT INTO Empleados (Nombre, Apellido, DepartamentoID, FechaContratacion) VALUES
('Juan', 'Pérez', 2, '2020-01-15'),
('María', 'Gómez', 1, '2019-03-10'),
('Luis', 'Martínez', 3, '2021-07-22'),
('Ana', 'Lopez', NULL, '2022-06-01');

-- Insertar datos en Proyectos
INSERT INTO Proyectos (Nombre, FechaInicio, FechaFin) VALUES
('Sistema de Inventarios', '2021-01-01', '2021-12-31'),
('Plataforma de E-learning', '2022-05-01', NULL),
('Aplicación Móvil', '2023-01-01', '2023-06-30');

-- Insertar datos en EmpleadosProyectos
INSERT INTO EmpleadosProyectos (EmpleadoID, ProyectoID, HorasAsignadas) VALUES
(1, 1, 100),
(1, 2, 50),
(2, 1, 75),
(3, 3, 40);

-- Insertar datos en Clientes
INSERT INTO Clientes (Nombre, Pais) VALUES
('Empresa A', 'Guatemala'),
('Empresa B', 'México'),
('Empresa C', 'Colombia');

-- Insertar datos en ProyectosClientes
INSERT INTO ProyectosClientes (ProyectoID, ClienteID) VALUES
(1, 1),
(2, 2),
(3, 3),
(2, 3);




-------------------Consultas-------------------

-- 1. INNER JOIN: Obtener empleados y sus proyectos.

SELECT e.Nombre AS Empleado, p.Nombre AS Proyecto
FROM Empleados e
INNER JOIN EmpleadosProyectos ep ON e.EmpleadoID = ep.EmpleadoID
INNER JOIN Proyectos p ON ep.ProyectoID = p.ProyectoID;

-- 2. LEFT JOIN: Lista de empleados con los proyectos a los que están asignados (incluyendo empleados sin proyectos).

SELECT e.Nombre AS Empleado, p.Nombre AS Proyecto
FROM Empleados e
LEFT JOIN EmpleadosProyectos ep ON e.EmpleadoID = ep.EmpleadoID
LEFT JOIN Proyectos p ON ep.ProyectoID = p.ProyectoID;


-- 3. RIGHT JOIN: Lista de proyectos y los empleados asignados (incluyendo proyectos sin empleados asignados).

SELECT e.Nombre AS Empleado, p.Nombre AS Proyecto
FROM Empleados e
RIGHT JOIN EmpleadosProyectos ep ON e.EmpleadoID = ep.EmpleadoID
RIGHT JOIN Proyectos p ON ep.ProyectoID = p.ProyectoID;

-- 4. FULL JOIN: Lista de empleados y proyectos (incluyendo empleados y proyectos sin asignar).

SELECT e.Nombre AS Empleado, p.Nombre AS Proyecto
FROM Empleados e
FULL JOIN EmpleadosProyectos ep ON e.EmpleadoID = ep.EmpleadoID
FULL JOIN Proyectos p ON ep.ProyectoID = p.ProyectoID;

-- 5. FULL OUTER JOIN: Empleados y proyectos, incluyendo los empleados sin proyectos y proyectos sin empleados.

SELECT e.Nombre AS Empleado, p.Nombre AS Proyecto
FROM Empleados e
FULL OUTER JOIN EmpleadosProyectos ep ON e.EmpleadoID = ep.EmpleadoID
FULL OUTER JOIN Proyectos p ON ep.ProyectoID = p.ProyectoID;

-- 6. Joins con múltiples tablas: Proyectos y sus clientes, junto con los empleados que trabajan en esos proyectos.

SELECT p.Nombre AS Proyecto, c.Nombre AS Cliente, e.Nombre AS Empleado
FROM Proyectos p
INNER JOIN ProyectosClientes pc ON p.ProyectoID = pc.ProyectoID
INNER JOIN Clientes c ON pc.ClienteID = c.ClienteID
LEFT JOIN EmpleadosProyectos ep ON p.ProyectoID = ep.ProyectoID
LEFT JOIN Empleados e ON ep.EmpleadoID = e.EmpleadoID;



--------- llamadas a procedimientos --------

CALL AgregarEmpleado('Bryan', 'Paez', 1, now()::DATE);
CALL AgregarEmpleado('Daniela', 'Garcia', 2, now()::DATE);

CALL ActualizarHorasEmpleadoProyecto(1, 2, 80);
CALL ActualizarHorasEmpleadoProyecto(2, 1, 90);

--------- llamadas a funciones --------

SELECT * FROM ListarProyectosbyCliente(1);
SELECT * FROM ListarProyectosbyCliente(2);
SELECT * FROM ListarProyectosbyCliente(3);


SELECT ObtenerNombreCompleto(1);
SELECT ObtenerNombreCompleto(2);

SELECT ContarProyectosDeEmpleado(1);
SELECT ContarProyectosDeEmpleado(2);

SELECT * FROM ObtenerProyectosDeCliente(1);
SELECT * FROM ObtenerProyectosDeCliente(2);

SELECT ObtenerTotalHorasPorProyecto(1);
SELECT ObtenerTotalHorasPorProyecto(2);


SELECT EstaAsignadoAProyecto(1, 1);
SELECT EstaAsignadoAProyecto(1, 2);