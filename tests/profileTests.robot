*** Settings ***
Documentation       Suite to verify all profile endpoints with basic status checks.
...                 This suite ensures the API responds with correct status codes and functions as expected, without detailed data validation. Smoke Test
Metadata            Version    0.1

Library             RequestsLibrary
Library             JSONLibrary
Library             String
Resource            resources.robot

# Suite Setup    Get Set accessToken
# Suite Setup    Create Random Profile
# Suite Teardown    Delete Profile    ${token}    ${profile_id}
Test Timeout        1 minutes


*** Test Cases ***
Create Profile
    Create Random Profile

Get Profile
    Fetch Profile Info

Update Profile
    Update Profile

Delete Profile
    Delete Profile    ${token}    ${profile_id}


*** Keywords ***
Fetch Profiles
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET    ${PROFILE_URL}    headers=${headers}
    Log    ${response.json()}
    Log    ${token}
    Should Be Equal As Numbers    ${response.status_code}    200

Fetch Profile Info
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET    ${PROFILE_SELF_URL}    headers=${headers}
    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

Fetch Profile ID
    ${profile_id}=    Get Profile Id    ${token}
    Log    ${profile_id}

Update Profile
    ${body}=    Create Dictionary    username=UpdatedUser    password=my_password
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    PUT    ${API_URL}/profile    json=${body}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
# Perform Login2
#    ${body}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
#    ${json_body}=    Evaluate    '{"username": "${VALID_USERNAME}", "password": "${VALID_PASSWORD}"}'
#    ${content_length}=    Get Length    ${json_body}
#    ${content_length_str}=    Evaluate    str(${content_length})
#    ${headers}=    Create Dictionary    Content-Type=application/json    Host=altzone.fi    Content-Length=${content_length_str}
#    ${response}=    POST    ${LOGIN_URL}    json=${body}    headers=${headers}
#    Should Be Equal As Numbers    ${response.status_code}    201

# Perform Login3
#    ${body}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
#    ${headers}=    Create Dictionary    Content-Type=application/json
#    ${response}=    POST    ${LOGIN_URL}    json=${body}    headers=${headers}
#    Should Be Equal As Numbers    ${response.status_code}    201
