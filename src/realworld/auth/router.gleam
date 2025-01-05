import gleam/dynamic/decode
import gleam/http
import gleam/json
import gleam/result
import wisp.{type Request, type Response}

pub fn user_handler(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["users"] -> {
      use <- wisp.require_method(req, http.Post)
      register(req)
    }
    ["users", "login"] -> {
      use <- wisp.require_method(req, http.Post)
      login(req)
    }
    ["user"] -> user(req)
    _ -> wisp.not_found()
  }
}

fn register(req: Request) -> Response {
  use json <- wisp.require_json(req)
  let result = {
    use data <- result.try(decode.run(json, registration_decoder()))
    let object =
      json.object([
        #(
          "user",
          json.object([
            #("email", json.string(data.user.email)),
            #("token", json.string("")),
            #("username", json.string(data.user.username)),
            #("bio", json.string("")),
            #("image", json.string("")),
          ]),
        ),
      ])
    Ok(json.to_string_tree(object))
  }
  case result {
    Ok(json) -> wisp.json_response(json, 201)
    Error(_) -> wisp.unprocessable_entity()
  }
}

pub type RegistrationRequestJson {
  RegistrationRequestJson(user: UserRegistrationRequestJson)
}

pub type UserRegistrationRequestJson {
  UserRegistrationRequestJson(email: String, password: String, username: String)
}

pub fn registration_decoder() {
  let user_registration_decoder = {
    use email <- decode.field("email", decode.string)
    use password <- decode.field("password", decode.string)
    use username <- decode.field("username", decode.string)
    decode.success(UserRegistrationRequestJson(email:, password:, username:))
  }
  use user <- decode.field("user", user_registration_decoder)
  decode.success(RegistrationRequestJson(user:))
}

fn login(_req: Request) -> Response {
  todo
}

fn user(req: Request) -> Response {
  case req.method {
    http.Get -> get_user(req)
    http.Put -> put_user(req)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn get_user(_req: Request) -> Response {
  todo
}

fn put_user(_req: Request) -> Response {
  todo
}
