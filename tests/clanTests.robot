*** Settings ***
Documentation       Suite to verify all clan endpoints with basic status checks.
...                 This suite ensures the API responds with correct status codes and functions as expected, without detailed data validation. Smoke Test
Metadata            Version    0.1

Library             RequestsLibrary
Library             JSONLibrary
Library             String
Resource            resources.robot

# Suite Setup    Get Static accessToken
Suite Setup         Create Random Profile
Suite Teardown      Delete Profile    ${token}    ${profile_id}
Test Timeout        1 minutes


*** Variables ***
${clan_id}      ${EMPTY}


*** Test Cases ***
Get Clans
    Fetch Clan List

Create Clan
    Create Clan

Get Created Clan
    Fetch One Clan

Update Clan
    Update Clan

Fetch Secondary Profile
    [Documentation]    Fetch secondary accessToken to test joining/leaving
    ...    the clan that initial Profile created.
    ${testerToken}=    Get accessToken    ${setUsername}    ${setPassword}
    Join Clan    ${testerToken}
    Leave Clan    ${testerToken}

Delete Clan
    Delete Clan


*** Keywords ***
Fetch Clan List
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    GET    ${CLAN_URL}    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

Fetch One Clan
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    GET    ${CLAN_URL}/${clan_id}    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

Create Clan
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}

    ${clan_logo}=    Create Dictionary
    ...    logoType=Heart
    ...    pieceColors=${{["#FF5733", "#33FF57", "#3357FF"]}}

    ${body}=    Create Dictionary
    ...    name=testClana
    ...    isOpen=${True}
    ...    labels=${{["eläinrakkaat", "itsenäiset"]}}
    ...    ageRange=Adults
    ...    goal=Grindaus
    ...    phrase=Adults
    ...    language=Finnish
    ...    tag=tagi
    ...    clanLogo=${clan_logo}

    ${response}=    POST    ${CLAN_URL}    json=${body}    headers=${headers}
    Log    ${response.json()}
    ${clan_id_obj}=    Get Value From Json    ${response.json()}    $.data.Clan._id    fail_on_empty=True
    Log    ${clan_id_obj}
    ${clan_id}=    Set Variable    ${clan_id_obj}[0]
    Set Suite Variable    ${clan_id}
    Should Be Equal As Numbers    ${response.status_code}    201

Delete Clan
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    DELETE    ${CLAN_URL}/${clan_id}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200

Update Clan
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}

    ${body}=    Create Dictionary
    ...    _id=${clan_id}
    ...    name=testClanUpdated

    ${response}=    PUT    ${CLAN_URL}    json=${body}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200

Join Clan
    [Arguments]    ${testerToken}
    ${player_id}=    Get Player Id    ${testerToken}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${testerToken}

    ${body}=    Create Dictionary
    ...    clan_id=${clan_id}
    ...    player_id=${player_id}
    ...    join_message=tester wants to join

    ${response}=    POST    ${CLAN_URL}/join    json=${body}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    201

Leave Clan
    [Arguments]    ${testerToken}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${testerToken}

    ${response}=    POST    ${CLAN_URL}/leave    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    204
