*** Settings ***
Documentation       Suite to verify all leaderboard endpoints with basic status checks.
...                 This suite ensures the API responds with correct status codes and functions as expected, without detailed data validation. Smoke Test
Metadata            Version    0.1

Library             RequestsLibrary
Library             JSONLibrary
Library             String
Resource            resources.robot

Test Timeout        1 minutes


*** Test Cases ***
Get Players Leaderboard
    Leaderboard Player

Get Clans Leaderboard
    Leaderboard Clan

Get My Clan Leaderboard
    ${testerToken}=    Get accessToken    ${testUser}    ${setPassword}
    Leaderboard My Clan    ${testerToken}


*** Keywords ***
Leaderboard Player
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    GET    ${LEADERBOARD_URL}/player    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

Leaderboard Clan
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    GET    ${LEADERBOARD_URL}/clan    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

Leaderboard My Clan
    [Arguments]    ${testerToken}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${testerToken}
    ${response}=    GET    ${LEADERBOARD_URL}/clan/position    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200
