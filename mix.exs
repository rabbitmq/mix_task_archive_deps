## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at https://mozilla.org/MPL/2.0/.
##
## Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  All rights reserved.

defmodule MixTaskArchiveDeps.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mix_task_archive_deps,
      version: "1.0.0",
      elixir: "~> 1.11",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "Mix task to create archives for a project dependencies and Elixir itself",
      package: package(),
      deps: deps(),
      name: "MixTaskArchiveDeps",
      source_url: "https://github.com/rabbitmq/mix_task_archive_deps"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.29.1", only: :dev, runtime: false}]
  end

  defp package() do
    [
      name: :mix_task_archive_deps,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Luke Bakken", "Michael Klishin"],
      licenses: ["MPL 2.0"],
      links: %{"GitHub" => "https://github.com/rabbitmq/mix_task_archive_deps"}
    ]
  end
end
