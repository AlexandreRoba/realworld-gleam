import dot_env
import dot_env/env
import gleam/erlang/process
import mist
import realworld/router
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load

  let assert Ok(port) = env.get_int("PORT")
  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE")

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, secret_key_base)
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}
