class Outrunner < Formula
  desc "Ephemeral GitHub Actions runners, no Kubernetes required"
  homepage "https://github.com/NetwindHQ/gha-outrunner"
  version "0.1.0-rc1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_darwin_arm64.tar.gz"
      sha256 "46c1636ea4a07d039dca35c25a5326ede8dd04c9969e81c78e93b84aed721af6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_linux_amd64.tar.gz"
      sha256 "3644e55b58f11e42286e116600129ea356cb2b51daeb53944da8a34e041c6fca"
    end
    on_arm do
      url "https://github.com/NetwindHQ/gha-outrunner/releases/download/v#{version}/gha-outrunner_#{version}_linux_arm64.tar.gz"
      sha256 "0ee8731baee39746e20d109393319aacd232b8f751bfd37f4ff6a3218334463c"
    end
  end

  def install
    bin.install "outrunner"
    etc.install "config.yml" => "outrunner/config.yml" if File.exist? "config.yml"
  end

  service do
    run [opt_bin/"outrunner", "--config", etc/"outrunner/config.yml"]
    keep_alive true
    log_path var/"log/outrunner.log"
    error_log_path var/"log/outrunner.log"
  end

  def caveats
    <<~EOS
      To configure outrunner, edit:
        #{etc}/outrunner/config.yml

      Set your GitHub token via environment or file:
        echo 'GITHUB_TOKEN=ghp_...' > #{etc}/outrunner/env
        chmod 600 #{etc}/outrunner/env

      Start the service:
        brew services start outrunner
    EOS
  end
end
