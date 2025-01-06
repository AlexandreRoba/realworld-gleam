import gleam/dynamic/decode
import gleam/json
import gleam/result
import wisp.{type Request, type Response}

pub fn register(req: Request) -> Response {
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

type RegistrationRequestJson {
  RegistrationRequestJson(user: UserRegistrationRequestJson)
}

type UserRegistrationRequestJson {
  UserRegistrationRequestJson(email: String, password: String, username: String)
}

fn registration_decoder() {
  let user_registration_decoder = {
    use email <- decode.field("email", decode.string)
    use password <- decode.field("password", decode.string)
    use username <- decode.field("username", decode.string)
    decode.success(UserRegistrationRequestJson(email:, password:, username:))
  }
  use user <- decode.field("user", user_registration_decoder)
  decode.success(RegistrationRequestJson(user:))
}

pub fn login(_req: Request) -> Response {
  todo
}

pub fn get_user(_req: Request) -> Response {
  todo
}

pub fn update_user(_req: Request) -> Response {
  todo
}
