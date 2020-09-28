## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at https://mozilla.org/MPL/2.0/.
##
## Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  All rights reserved.


defmodule Mix.Tasks.Archive.Build.Deps do
  use Mix.Task
  alias  Mix.Archive.Build.Helpers, as: Helpers

  @shortdoc "Archives the project dependencies into .ez files"

  @moduledoc """
  Builds each dependency into archives according to the specification of the
  [Erlang Archive Format](https://www.erlang.org/doc/man/code.html).

  Archives are prebuild packages, which can be used by both Erlang and Elixir
  without Mix or other dependency management tools.

  The archives will be created in the "archives" subdirectory of
  the project build directory by default, unless an argument `-o` is
  provided with the directory name.

  ## Command line options

  * `-o` - specifies output directory name.
      Defaults to BUILD_DIR/archives

  * `--skip` - a space-separated list of dependencies to skip
  """

  @switches [destination: :string, skip: :string]
  @aliases [o: :destination]

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    {opts, _} = OptionParser.parse!(argv, aliases: @aliases, strict: @switches)
    build_archives(opts)
  end

  def build_archives(opts) do
    list(opts)
    |>  Enum.each(fn({app_dir, archive_path}) ->
          Mix.Tasks.Archive.Build.run(["-i", app_dir, "-o", archive_path])
        end)
    :ok
  end

  def list_archives(opts) do
    list(opts)
    |> Enum.map(fn({_, archive_path}) -> archive_path end)
  end

  defp list(opts) do
    build_path = Mix.Project.build_path
    destination = Helpers.destination(opts)
    skip = Helpers.skipped_apps(opts)

    ## Build delendencies archives
    Mix.Dep.load_on_environment(env: Mix.env)
    |>  Enum.filter(fn(%Mix.Dep{app: app}) -> not Enum.member?(skip, app) end)
    |>  Enum.map(fn(%Mix.Dep{app: app, status: status}) ->
      version = case status do
        {:ok, vsn} when vsn != nil -> vsn
        reason -> :erlang.error({:invalid_status, reason})
      end
      archive_path = Path.join([destination, "#{app}-#{version}.ez"])
      app_dir = Path.join([build_path, "lib", "#{app}"])
      {app_dir, archive_path}
    end)
  end
end
