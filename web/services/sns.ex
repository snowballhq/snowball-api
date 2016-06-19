defmodule Snowball.SNS do
  use ExAws.SNS.Client, otp_app: :snowball
end
