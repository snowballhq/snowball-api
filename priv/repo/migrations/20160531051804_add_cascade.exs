defmodule Snowball.Repo.Migrations.AddCascade do
  use Ecto.Migration

  def change do
    alter table(:follows) do
      modify :following_id, references(:users, type: :uuid, on_delete: :delete_all)
      modify :follower_id, references(:users, type: :uuid, on_delete: :delete_all)
    end

    alter table(:clips) do
      modify :user_id, references(:users, type: :uuid, on_delete: :delete_all)
    end

    alter table(:likes) do
      modify :user_id, references(:users, type: :uuid, on_delete: :delete_all)
      modify :clip_id, references(:clips, type: :uuid, on_delete: :delete_all)
    end

    alter table(:flags) do
      modify :clip_id, references(:clips, type: :uuid, on_delete: :delete_all)
    end

    alter table(:devices) do
      modify :user_id, references(:users, type: :uuid, on_delete: :delete_all)
    end
  end
end
