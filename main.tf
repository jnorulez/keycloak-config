terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 2.2.0"
    }
  }
}

provider "keycloak" {
  client_id      = "admin-cli"
  username       = "admin" # caution: in a real szenario, the credentials would never be hardcoded here!
  password       = "secret" # even more caution!!!
  url            = "http://localhost:8080"
  client_timeout = 30
}

resource "keycloak_realm" "realm" {
  realm                                = "example-realm"
  display_name                         = "Example Realm"
  enabled                              = true
  access_code_lifespan                 = "30m"
  sso_session_idle_timeout             = "30m"
  sso_session_max_lifespan             = "10h"
  offline_session_idle_timeout         = "720h"
  offline_session_max_lifespan_enabled = false
  registration_allowed                 = true
  registration_email_as_username       = true
  reset_password_allowed               = true
  verify_email                         = true
  login_with_email_allowed             = true
  account_theme                        = "keycloak"
  admin_theme                          = "keycloak"
  email_theme                          = "keycloak"
  login_theme                          = "keycloak"

  internationalization {
    supported_locales = [
      "de",
    ]
    default_locale = "de"
  }
  password_policy = "upperCase(1) and length(8) and notUsername(undefined)"

  smtp_server {
    from     = "your email"
    host     = "your smtp host"
    ssl      = false
    starttls = false
    auth {
      username = "your username"
      password = "your password"
    }
  }
}

resource "keycloak_openid_client" "service" {
  client_id                                = "example-client"
  name                                     = "Example Client"
  realm_id                                 = keycloak_realm.realm.id
  access_type                              = "PUBLIC"
  access_token_lifespan                    = 600
  direct_access_grants_enabled             = false
  enabled                                  = true
  standard_flow_enabled                    = true
  service_accounts_enabled                 = false
  exclude_session_state_from_auth_response = false
  valid_redirect_uris                      = ["https://yourredirecturi.de/"]
}
