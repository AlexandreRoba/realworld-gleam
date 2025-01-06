import gleam/http
import realworld/users/web.{get_user, login, register, update_user}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["user"] if req.method == http.Get -> get_user(req)
    ["user"] if req.method == http.Put -> update_user(req)
    ["users"] if req.method == http.Post -> register(req)
    ["users", "login"] if req.method == http.Post -> login(req)
    _ -> wisp.not_found()
  }
}
