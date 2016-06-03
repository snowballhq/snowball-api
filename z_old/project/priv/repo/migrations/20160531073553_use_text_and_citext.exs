defmodule Snowball.Repo.Migrations.UseTextAndCitext do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"citext\""

    alter table(:users) do
      modify :username, :citext
      modify :password_digest, :text
      modify :name, :text
      modify :email, :citext
      modify :phone_number, :text
      modify :auth_token, :text
      modify :reset_password_token, :text
      modify :avatar_file_name, :text
      modify :avatar_content_type, :text
      modify :avatar_file_size, :text
    end

    alter table(:clips) do
      modify :video_file_name, :text
      modify :video_content_type, :text
      modify :thumbnail_file_name, :text
      modify :thumbnail_content_type, :text
      modify :video_file_size, :text
      modify :thumbnail_file_size, :text
    end

    alter table(:devices) do
      modify :arn, :text
    end
  end
end
