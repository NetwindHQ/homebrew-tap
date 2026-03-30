class Outrunner < Formula
  desc "Ephemeral GitHub Actions runners, no Kubernetes required"
  homepage "https://github.com/NetwindHQ/gha-outrunner"
  version "0.1.0-rc3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_darwin_arm64.tar.gz"
      sha256 "9b2fd173e862673a2b33476450e1fa51bcec7aa269d89cb0eac73f9d16ccf594"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_linux_amd64.tar.gz"
      sha256 "48b895984d007b68062b53f2454acf121add6a27aa65a18a5df5d0b303ac5d70"
    end
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_linux_arm64.tar.gz"
      sha256 "757f11844356be4d8b56cc9745eb94224b122706cecf524ff8fbb37b45b938fd"
    end
  end

  def install
    bin.install "outrunner"
    (etc/"outrunner").mkpath
    unless (etc/"outrunner/config.yml").exist?
      (etc/"outrunner/config.yml").write <<~YAML
        # outrunner configuration
        # See https://github.com/NetwindHQ/gha-outrunner/blob/main/docs/reference/configuration.md

        url: https://github.com/your-org/your-repo
        token_file: #{etc}/outrunner/token

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
