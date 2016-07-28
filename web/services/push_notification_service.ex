defmodule Snowball.PushNotificationService do
  use ExAws.SNS.Client, otp_app: :snowball

  import SweetXml

  def register_installation_token(token) do
    if Mix.env == :test do
      # This is here to stub in the test environment. Figure out a better way.
      unless token == "" do
        "arn:aws:sns:us-west-2:235811926729:endpoint/APNS/snowball-ios-production/514e2e2a-0990-36e7-bc0c-04548bf13572"
      end
    else
      case Snowball.PushNotificationService.create_platform_endpoint(System.get_env("AWS_SNS_ARN_IOS"), token) do
        {:ok, response} ->
          response.body |> xpath(~x"//EndpointArn/text()"s)
        {:error, _error} ->
          nil
      end
    end
  end

  def send_push_to_installation_arn(message, arn) do
    unless Mix.env == :test do
      Snowball.PushNotificationService.publish(message, %{target_arn: arn})
    end
  end
end
