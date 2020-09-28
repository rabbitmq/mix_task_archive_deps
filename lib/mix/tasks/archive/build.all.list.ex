## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at https://mozilla.org/MPL/2.0/.
##
## Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  All rights reserved.

defmodule Mix.Tasks.Archive.Build.All.List do
  use Mix.Task

  @shortdoc "Lists .ez archives to be built with Archive.Build.All"

  @moduledoc """
  ## Command line options

  * `-o|--destination` - specifies output directory name.
      Defaults to BUILD_DIR/archives

  * `-e|--elixir` - specifies if all elixir applications
      should be archived. Defaults to `false`

  * `-s|--separator` - character to use as separator
    when listing archives

  * `--skip` - a space-separated list of dependencies to skip
  """

  @switches [destination: :string, elixir: :boolean, separator: :string, skip: :string]
  @aliases [o: :destination, e: :elixir, s: :separator]

  @spec run(OptionParser.argv()) :: :ok
  def run(argv) do
    Mix.Tasks.Loadpaths.run([])
    {opts, _} = OptionParser.parse!(argv, aliases: @aliases, strict: @switches)
    destination = Mix.Archive.Build.Helpers.destination(opts)
    elixir = opts[:elixir] || false
    separator = opts[:separator] || "\n"

    archive_name = Mix.Local.name_for(:archives, Mix.Project.config())
    archive_path = Path.join([destination, archive_name])

    deps_archives = Mix.Tasks.Archive.Build.Deps.list_archives(opts)

    elixir_archives =
      if elixir do
        Mix.Tasks.Archive.Build.Elixir.list_archives(opts)
      else
        []
      end

    [[archive_path], deps_archives, elixir_archives]
    |> Enum.concat()
    |> Enum.join(separator)
    |> IO.puts()

    :ok
  end
end
