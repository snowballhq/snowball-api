defmodule Snowball.Repo.Migrations.Sync do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :username, :string, null: false
      add :password_digest, :string, null: false
      add :name, :string
      add :email, :string, null: false
      add :phone_number, :string
      add :auth_token, :string, null: false
      timestamps [inserted_at: :created_at]
      add :reset_password_token, :string
      add :reset_password_sent_at, :datetime
      add :avatar_file_name, :string
      add :avatar_content_type, :string
      add :avatar_file_size, :string
      add :avatar_updated_at, :datetime
    end

    create index(:users, [:auth_token], name: :index_users_on_auth_token)
    create index(:users, [:email], name: :index_users_on_email)
    create index(:users, [:reset_password_token], name: :index_users_on_reset_password_token)
    create index(:users, [:username], name: :index_users_on_username)

    create table(:follows, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :following_id, :uuid, null: false
      add :follower_id, :uuid, null: false
      timestamps [inserted_at: :created_at]
    end

    create table(:clips, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :user_id, :uuid, null: false
      add :video_file_name, :string, null: false
      add :video_content_type, :string, null: false
      add :thumbnail_file_name, :string, null: false
      add :thumbnail_content_type, :string, null: false
      timestamps [inserted_at: :created_at]
      add :video_file_size, :string
      add :thumbnail_file_size, :string
      add :video_updated_at, :datetime
      add :thumbnail_updated_at, :datetime
    end

    create table(:likes, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :user_id, :uuid, null: false
      add :clip_id, :uuid, null: false
      timestamps [inserted_at: :created_at]
    end
  end
end
