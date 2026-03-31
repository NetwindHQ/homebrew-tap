class Outrunner < Formula
  desc "Ephemeral GitHub Actions runners, no Kubernetes required"
  homepage "https://github.com/NetwindHQ/gha-outrunner"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_darwin_arm64.tar.gz"
      sha256 "1d8d8aa6c5b3a6fbf9f04626849f0567ad4a33c30d25cc81194f3370822896ef"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_amd64.tar.gz"
      sha256 "061a3fe930977e03c32469b93c57c77761bc326ade47731b4e789dc1d816ca3b"
    end
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_arm64.tar.gz"
      sha256 "31885dc2fc00e06c63aeafe023ac2a5937399cd752ab86f79088e4e0f51127e2"
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
