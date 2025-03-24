-- Tabla: Empleados
CREATE TABLE Empleados (
    EmpleadoID SERIAL PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    DepartamentoID INT,
    FechaContratacion DATE,
    FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(DepartamentoID)
);

-- Tabla: Departamentos
CREATE TABLE Departamentos (
    DepartamentoID SERIAL PRIMARY KEY,
    Nombre VARCHAR(50)
);

-- Alteración para agregar la relación entre Empleados y Departamentos
ALTER TABLE Empleados
ADD CONSTRAINT fk_departamento
FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(DepartamentoID);

-- Tabla: Proyectos
CREATE TABLE Proyectos (
    ProyectoID SERIAL PRIMARY KEY,
    Nombre VARCHAR(50),
    FechaInicio DATE,
    FechaFin DATE
);

-- Tabla: EmpleadosProyectos (Relación muchos a muchos entre Empleados y Proyectos)
CREATE TABLE EmpleadosProyectos (
    EmpleadoID INT,
    ProyectoID INT,
    HorasAsignadas INT,
    PRIMARY KEY (EmpleadoID, ProyectoID),
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    FOREIGN KEY (ProyectoID) REFERENCES Proyectos(ProyectoID)
);

-- Tabla: Clientes
CREATE TABLE Clientes (
    ClienteID SERIAL PRIMARY KEY,
    Nombre VARCHAR(50),
    Pais VARCHAR(50)
);

-- Tabla: ProyectosClientes (Relación entre Proyectos y Clientes)
CREATE TABLE ProyectosClientes (
    ProyectoID INT,
    ClienteID INT,
    PRIMARY KEY (ProyectoID, ClienteID),
    FOREIGN KEY (ProyectoID) REFERENCES Proyectos(ProyectoID),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);


-- Tabla: Bitacora

CREATE TABLE Bitacora (
    BitacoraID SERIAL PRIMARY KEY,
    Fecha TIMESTAMP,
    Tabla VARCHAR(50),
    Operacion VARCHAR(50),
    Usuario VARCHAR(50)
);

