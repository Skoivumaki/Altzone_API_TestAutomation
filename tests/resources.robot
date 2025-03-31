*** Settings ***
Documentation
...                 This resource library provides reusable essential keywords to streamline API endpoint testing.

Library             RequestsLibrary
Library             JSONLibrary
Library             String


*** Variables ***
${API_URL}              https://altzone.fi/api
${setUsername}          user1132
${testUser}             user82970
${setPassword}          my_password
${PROFILE_URL}          ${API_URL}/profile
${PROFILE_SELF_URL}     ${API_URL}/profile/info
${CLAN_URL}             ${API_URL}/clan
${LEADERBOARD_URL}      ${API_URL}/leaderboard
${PLAYER_URL}           ${API_URL}/player
${profile_id}           ${EMPTY}
${token}                ${EMPTY}


*** Keywords ***
Perform Login
    ${response}=    POST
    ...    ${API_URL}/auth/signIn
    ...    json={{"username": "${setUsername}", "password": "${setPassword}"}}
    Log    ${response}
    Should Be Equal As Numbers    ${response.status_code}    201
    RETURN    ${response}

Get Static accessToken
    ${body}=    Create Dictionary    username=${setUsername}    password=${setPassword}
    ${response}=    POST    ${API_URL}/auth/signIn    json=${body}
    Log    ${response.json()}
    ${token_obj}=    Get Value From Json    ${response.json()}    accessToken    fail_on_empty=True
    Should Be Equal As Numbers    ${response.status_code}    201
    Log    ${token_obj}[0]
    ${token}=    Set Variable    ${token_obj}[0]
    Set Suite Variable    ${token}
    RETURN    ${token}

Get accessToken
    [Arguments]    ${username}    ${password}
    ${body}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST    ${API_URL}/auth/signIn    json=${body}
    Log    ${response.json()}
    ${token_obj}=    Get Value From Json    ${response.json()}    accessToken    fail_on_empty=True
    Should Be Equal As Numbers    ${response.status_code}    201
    Log    ${token_obj}[0]
    ${token}=    Set Variable    ${token_obj}[0]
    RETURN    ${token}

Delete Profile
    [Arguments]    ${token}    ${profile_id}
    Log    ${profile_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    DELETE    ${API_URL}/profile/${profile_id}    headers=${headers}
    Log    ${response.status_code}
    Should Be Equal As Numbers    ${response.status_code}    200

Create Profile
    [Arguments]
    ...    ${username}
    ...    ${password}
    ...    ${player_name}
    ...    ${unique_id}
    ...    ${above13}=${True}
    ...    ${parentalAuth}=${False}

    ${battle_ids}=    Create List    60c72b2f5f1b2c001c8e4d60    60c72b2f5f1b2c001c8e4d61
    ${avatarId}=    Convert To Integer    101
    ${backpackCapacity}=    Convert To Integer    50
    ${player}=    Create Dictionary
    ...    name=${player_name}
    ...    backpackCapacity=${backpackCapacity}
    ...    uniqueIdentifier=${unique_id}
    ...    above13=${above13}
    ...    parentalAuth=${parentalAuth}
    ...    battleCharacter_ids=${battle_ids}
    ...    currentAvatarId=${avatarId}

    ${body}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}
    ...    Player=${player}

    ${response}=    POST    ${API_URL}/profile    json=${body}
    Log    ${response.json()}

    Should Be Equal As Numbers    ${response.status_code}    201
    Set Suite Variable    ${username}
    Set Suite Variable    ${password}
    ${token}=    Get accessToken    ${username}    ${password}
    Set Suite Variable    ${token}
    ${profile_id}=    Get Profile Id    ${token}
    Set Suite Variable    ${profile_id}
    Log    ${profile_id}
    Log    ${token}
    RETURN    ${token}

Create Random Profile
    ${random_suffix}=    Generate Random String    5    [NUMBERS]
    ${random_user}=    Set Variable    user${random_suffix}
    ${profile}=    Create Profile    ${random_user}    my_password    ${random_user}    ${random_user}
    Log    ${profile}

Get Profile Id
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET    ${API_URL}/profile/info    headers=${headers}
    Log    ${response.json()}
    ${profile_id_obj}=    Get Value From Json    ${response.json()}    $.data.Profile._id    fail_on_empty=True
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${profile_id_obj}
    ${id}=    Set Variable    ${profile_id_obj}[0]
    RETURN    ${id}

Get Player Id
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET    ${API_URL}/profile/info    headers=${headers}
    Log    ${response.json()}
    ${player_id_obj}=    Get Value From Json    ${response.json()}    $.data.Profile.Player._id    fail_on_empty=True
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${player_id_obj}
    ${id}=    Set Variable    ${player_id_obj}[0]
    RETURN    ${id}
