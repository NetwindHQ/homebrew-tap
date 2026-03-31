class Outrunner < Formula
  desc "Ephemeral GitHub Actions runners, no Kubernetes required"
  homepage "https://github.com/NetwindHQ/gha-outrunner"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_darwin_arm64.tar.gz"
      sha256 "6ed5d278ada9b0399b0dcd55a869c620a03c834e321d078e7c5a25a6956e51bc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_amd64.tar.gz"
      sha256 "d6b8d187a53dbed3e1062afef21dc1cb5089f2605816db00c8d1c445554a65e6"
    end
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_arm64.tar.gz"
      sha256 "3a80aa15d6b233b16dca83b2dfc4385c62cdaa7a2c8cd9b127588f85d78dfe95"
    end
  end

  def install
    bin.install "outrunner"
    (etc/"outrunner").mkpath
    unless (etc/"outrunner/config.yml").exist?
      (etc/"outrunner/config.yml").write <<~YAML
        # outrunner configuration
        # See https://github.com/NetwindHQ/gha-outrunner/blob/main/docs/reference/configuration.md
        #
        # Quick setup:
        #   1. Set the url below to your GitHub repository or organization
        #   2. Put your GitHub token into #{etc}/outrunner/token
        #   3. Uncomment the runners section and adjust to your needs
        #   4. Start the service: brew services start outrunner

        url: https://github.com/your-org/your-repo
        token_file: #{etc}/outrunner/token

        # Uncomment and adjust the runners section below.
        # Each entry creates a scale set that GitHub routes jobs to based on labels.
        # runners:
        #   linux:
        #     labels: [self-hosted, linux]
        #     docker:
        #       image: ghcr.io/actions/actions-runner:latest
      YAML
    end
  end

  service do
    run [opt_bin/"outrunner", "--config", etc/"outrunner/config.yml"]
    keep_alive true
    log_path var/"log/outrunner.log"
    error_log_path var/"log/outrunner.log"
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:#{HOMEBREW_PREFIX}/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  def caveats
    <<~EOS
      Edit the config:
        #{etc}/outrunner/config.yml

      Put your GitHub token into #{etc}/outrunner/token
      then: chmod 600 #{etc}/outrunner/token

      See https://github.com/NetwindHQ/gha-outrunner/blob/main/docs/setup/macos.md

      Start the service:
        brew services start outrunner
    EOS
  end
end
