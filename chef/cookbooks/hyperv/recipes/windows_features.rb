raise if not node[:platform] == 'windows'

node.default[:windows][:allow_pending_reboots] = false

if node[:target_platform] !~ /^hyperv/
  node[:features_list][:windows].each do |feature_name, feature_attrs|
    next if node[:windows_features_installed].include? feature_name

    windows_feature feature_name do
      action :install
      all feature_attrs["all"] || true
      restart feature_attrs["restart"] || false
    end

    node.default[:windows_features_installed].push feature_name
    node.save
  end

  windows_reboot 60 do
    reason 'Installing required Windows features requires a reboot'
    action :request
  end
end

