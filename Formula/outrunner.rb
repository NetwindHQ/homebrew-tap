class Outrunner < Formula
  desc "Ephemeral GitHub Actions runners, no Kubernetes required"
  homepage "https://github.com/NetwindHQ/gha-outrunner"
  version "1.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_darwin_arm64.tar.gz"
      sha256 "bc382a561a789e52461ae15759312c580401bb796c0416906b09515a8611d5d2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_amd64.tar.gz"
      sha256 "833052df4918ec5020a4333a1c024920f69e9537a1edd5581fc3fda88c7f05b9"
    end
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_arm64.tar.gz"
      sha256 "a8852efdce77c49fd36a37811f04513af761480b05d356c8d97413e7d327b3c5"
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
