class Outrunner < Formula
  desc "Ephemeral GitHub Actions runners, no Kubernetes required"
  homepage "https://github.com/NetwindHQ/gha-outrunner"
  version "1.0.0-rc3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_darwin_arm64.tar.gz"
      sha256 "af8ab18ac81168005986e6c49b2257d7b90f4e5fbbc8385a40d98b0d5ddd0f16"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_linux_amd64.tar.gz"
      sha256 "5e577b9f90f9c6f822495f9da46610d0a2ef143a59cb7181683516eb749aa267"
    end
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_linux_arm64.tar.gz"
      sha256 "17d6f399614b688bc16c6752527a937a9dfa7a7180b5b60ead5bc173877e4071"
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

      See https://github.com/NetwindHQ/gha-outrunner/blob/main/docs/howto/launchd-service.md

      Start the service:
        brew services start outrunner
    EOS
  end
end
