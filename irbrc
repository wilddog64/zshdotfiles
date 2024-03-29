# require 'irb/completion'
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true
IRB.conf[:LOAD_MODULES] = [] unless IRB.conf.key?(:LOAD_MODULES)
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
IRB.conf[:SAVE_HISTORY] = 1000
unless IRB.conf[:LOAD_MODULES].include?('irb/completion')
    IRB.conf[:LOAD_MODULES] << 'irb/completion'
end
