@workspace
Feature: Workspace

  Background:
    Given base url https://api.clockify.me/api
    And header X-Api-Key = MTYyYTIzNDAtN2YyMC00ZmM1LWE1ZmEtMzBhY2NjYzljN2Rl
    And header Content-Type = application/json
    And header Accept = application/json

  @listarworkspace
  Scenario:Listar espacios de trabajo

    And endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    * define idWorkspace = $.[0].id
    * print 'idWorkspace'
    * print response

  @Workspace
  Scenario:Listar espacios de trabajo

    Given call Workspace.feature@listarworkspace
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{idWorkspace}}
    When execute method GET
    Then the status code should be 200
    And response should be $.name = Casa
    * print response


  @listarworkspacefall
  Scenario:Listar espacios de trabajo

    And endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 401
    * print response

  @crearworkspace
  Scenario:Crear espacios de trabajo

    And endpoint /v1/workspaces
    And body read(jsons/bodies/workspace.json)
    And set value "PinkyNuevo" of key name in body jsons/bodies/workspace.json
    When execute method POST
    Then the status code should be 201
    * print response
