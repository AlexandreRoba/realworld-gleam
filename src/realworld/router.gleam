import realworld/auth/router.{user_handler}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["users", ..] | ["user", ..] -> user_handler(req)
    _ -> wisp.not_found()
  }
}
