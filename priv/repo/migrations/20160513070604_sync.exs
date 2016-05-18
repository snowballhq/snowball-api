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
  end
end
