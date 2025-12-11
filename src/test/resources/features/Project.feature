@project
Feature: Project

  Background:
    Given base url $(env.base_url_clockify)
    And header X-Api-Key = NDUzOGQ3NjktODhmYy00Yjc1LWIwNDItNDdmM2EyNTUwZmZk
    And header Content-Type = application/json
    And header Accept = */*


  @ConsultarProyectoID @ready
  Scenario:Buscar proyecto por ID

    Given call Workspace.feature@listarworkspace
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/69284b44641ff34429480426
    When execute method GET
    Then the status code should be 200
    * print response


  @ListarProyecto @ready
  Scenario:Listar proyectos por workspace

    Given call Workspace.feature@listarworkspace
    And endpoint /v1/workspaces/{{idWorkspace}}/projects
    When execute method GET
    Then the status code should be 200
    * print response


  @ListarProyectoAccesoDenied @ready
  Scenario:Listar proyectos con workspace incorrecto

    And endpoint /v1/workspaces/69062621e79eff72ae1d2a0/projects
    When execute method GET
    Then the status code should be 403
    * print response


  @ConsultarProyectoBadRequest @ready
  Scenario:Buscar proyecto por ID-Bad Request

    Given call Workspace.feature@listarworkspace
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/6920d11b641ff34429e6be48
    When execute method GET
    Then the status code should be 400
    * print response

  @ConsultarProyectoNoAutorizado @ready
  Scenario:Buscar proyecto por ID-No Autorizado

    Given call Workspace.feature@listarworkspace
    And header X-Api-Key = NDUzOGQ3NjktODhmYy00Yjc1LWIwNDItNDdmM2EyNTUwZmZ
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/69332a548f1b0262b71f0942
    When execute method GET
    Then the status code should be 401
    * print response

  @ConsultarProyectoEndpointErroneo @ready
  Scenario:Buscar proyecto por ID-No Autorizado

    Given call Workspace.feature@listarworkspace
    And header X-Api-Key = NDUzOGQ3NjktODhmYy00Yjc1LWIwNDItNDdmM2EyNTUwZmZk
    And endpoint /v11/workspaces/{{idWorkspace}}/projects/6920d11b641ff34429e6be48
    When execute method GET
    Then the status code should be 404
    * print response


  @AgregarUsuarioaProyecto @regression
    Scenario: Agregar un usuario a un proyecto

    Given call Workspace.feature@listarworkspace
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/69284b362cc15e0d8ecc40a3/memberships
    And set value false of key remove in body jsons/bodies/AsignarRemoverUsuarios.json
    When execute method POST
    Then the status code should be 200
    * print response

  @RemoverUsuarioaProyecto @regression
  Scenario: Agregar un usuario a un proyecto

    Given call Project.feature@AgregarUsuarioaProyecto
    And call Workspace.feature@listarworkspace
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/69284b362cc15e0d8ecc40a3/memberships
    And set value true of key remove in body jsons/bodies/AsignarRemoverUsuarios.json
    When execute method POST
    Then the status code should be 200
    * print response



  @crearproyecto
  Scenario:Crear proyecto en workspace
   #Llamado por @ModificarEstadodeProyecto(abajo)
    Given call Workspace.feature@listarworkspace
    And endpoint /v1/workspaces/{{idWorkspace}}/projects
    And body read(jsons/bodies/CrearProyecto.json)
    And set value Karim of key name in body jsons/bodies/CrearProyecto.json
    When execute method POST
    Then the status code should be 201
    * print response
    * define idProject = $.id
    * print '{{idProject}}'

  @ModificarEstadodeProyecto
  Scenario: Modificar estado de un proyecto
   #Llamado por @EliminarProyecto(abajo)
    Given call Workspace.feature@listarworkspace
    And call Project.feature@crearproyecto
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/{{idProject}}
    And body read(jsons/bodies/ModificarProyecto.json)
    And set value true of key archived in body jsons/bodies/ModificarProyecto.json
    When execute method PUT
    Then the status code should be 200
    * print response

  @EliminarProyecto @do
  Scenario: Eliminar proyecto de un workspace

    Given call Workspace.feature@listarworkspace
    And call Project.feature@ModificarEstadodeProyecto
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/{{idProject}}
    When execute method DELETE
    Then the status code should be 200
    * print response






