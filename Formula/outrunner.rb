class Outrunner < Formula
  desc "Ephemeral GitHub Actions runners, no Kubernetes required"
  homepage "https://github.com/NetwindHQ/gha-outrunner"
  version "1.0.0-rc6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_darwin_arm64.tar.gz"
      sha256 "50a7c38830c5a0f66bc409d4fbe2262d5aba735c04a1b615f158b1b702b6a024"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_amd64.tar.gz"
      sha256 "a609d5a5c7373e64252bd83cd1f788e1dd835107b571f41fec371f593c2c46f9"
    end
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/outrunner_#{version}_linux_arm64.tar.gz"
      sha256 "9cc5e9a35c39d8c1a8ce3c3474903ee860d2b644ce9300e69ceb266a725dc710"
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
