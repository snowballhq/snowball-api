defmodule Snowball.Repo.Migrations.RenameFollowFollowingToFollowed do
  use Ecto.Migration

  def change do
    rename table(:follows), :following_id, to: :followed_id
  end
end
