defmodule Snowball.Repo.Migrations.RenameDevicesToInstallations do
  use Ecto.Migration

  def change do
    rename table(:devices), to: table(:installations)
  end
end
