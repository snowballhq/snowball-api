defmodule Snowball.Repo.Migrations.CleanUpAttachments do
  use Ecto.Migration

  def change do
    rename table(:users), :avatar_file_name, to: :avatar
    alter table(:users) do
      remove :avatar_content_type
      remove :avatar_file_size
      remove :avatar_updated_at
    end

    rename table(:clips), :video_file_name, to: :video
    alter table(:clips) do
      remove :video_content_type
      remove :video_file_size
      remove :video_updated_at

      modify :thumbnail_file_name, :text, null: true
      remove :thumbnail_content_type
      remove :thumbnail_file_size
      remove :thumbnail_updated_at
    end
  end
end
