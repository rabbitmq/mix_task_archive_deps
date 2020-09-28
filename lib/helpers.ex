## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at https://mozilla.org/MPL/2.0/.
##
## Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  All rights reserved.

defmodule Mix.Archive.Build.Helpers do
  def destination(opts) do
    opts[:destination] || Path.join(Mix.Project.build_path, "archives")
  end
  def skipped_apps(opts) do
    (opts[:skip] || "") |> String.split(" ") |> Enum.map(&String.to_atom/1)
  end
end
