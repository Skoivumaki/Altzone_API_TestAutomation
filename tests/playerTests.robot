*** Settings ***
Documentation       Suite to verify all player endpoints with basic status checks.
...                 This suite ensures the API responds with correct status codes and functions as expected, without detailed data validation.
...                 Additionally, the following test cases for endpoints are excluded as they pertain to edge cases and are not considered reliable for smoke testing:
...                 DELETE /player/ID
...                 POST /player
Metadata            Version    0.1

Library             RequestsLibrary
Library             JSONLibrary
Library             String
Resource            resources.robot

# Suite Setup    Get Static accessToken
Suite Setup         Create Random Profile
Suite Teardown      Delete Profile    ${token}    ${profile_id}
Test Timeout        1 minutes


*** Test Cases ***
Get Players List
    Fetch Players

Update Player
    Update Player

Get Updated Player
    Fetch Player


*** Keywords ***
Fetch Players
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET    ${PLAYER_URL}    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

Update Player
    ${player_id}=    Get Player Id    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    _id=${player_id}
    ...    name=userUpdated

    ${response}=    PUT    ${PLAYER_URL}    json=${body}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200

Fetch Player
    ${player_id}=    Get Player Id    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET    ${PLAYER_URL}/${player_id}    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200
