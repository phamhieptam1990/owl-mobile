import 'package:athena/common/constants/general.dart';

const amplifyconfig_prod = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                 "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "${ConitoConstantProd.cognitoIdentityPoolId}",
                            "Region": "${ConitoConstantProd.cognitoRegion}"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {    
                        "PoolId": "${ConitoConstantProd.cognitoUserPoolId}",
                        "AppClientId": "${ConitoConstantProd.cognitoClientId}",
                        "AppClientSecret": "${ConitoConstantProd.cognitoClientSecret}",
                        "Region": "${ConitoConstantProd.cognitoRegion}"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "${ConitoConstantProd.cognitoWebdomain}",
                            "AppClientId": "${ConitoConstantProd.cognitoClientId}",
                            "AppClientSecret": "${ConitoConstantProd.cognitoClientSecret}",
                            "SignInRedirectURI": "${ConitoConstantProd.cognitoUrlRedirect}",
                            "SignOutRedirectURI": "${ConitoConstantProd.cognitoUrlRedirectLogout}",
                            "Scopes": [
                                "email",
                                "openid",
                                "phone"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "GIVEN_NAME",
                            "FAMILY_NAME"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_UPPERCASE",
                                "REQUIRES_NUMBERS",
                                "REQUIRES_SYMBOLS"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    }
}''';
const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                 "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "${ConitoConstant.cognitoIdentityPoolId}",
                            "Region": "${ConitoConstant.cognitoRegion}"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {    
                        "PoolId": "${ConitoConstant.cognitoUserPoolId}",
                        "AppClientId": "${ConitoConstant.cognitoClientId}",
                        "AppClientSecret": "${ConitoConstant.cognitoClientSecret}",
                        "Region": "${ConitoConstant.cognitoRegion}"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "${ConitoConstant.cognitoWebdomain}",
                            "AppClientId": "${ConitoConstant.cognitoClientId}",
                            "AppClientSecret": "${ConitoConstant.cognitoClientSecret}",
                            "SignInRedirectURI": "${ConitoConstant.cognitoUrlRedirect}",
                            "SignOutRedirectURI": "${ConitoConstant.cognitoUrlRedirectLogout}",
                            "Scopes": [
                                "email",
                                "openid",
                                "phone"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "GIVEN_NAME",
                            "FAMILY_NAME"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_UPPERCASE",
                                "REQUIRES_NUMBERS",
                                "REQUIRES_SYMBOLS"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    }
}''';
