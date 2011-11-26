# Copyright (c) 2009-2011 by Ewout Vonk. All rights reserved.
# Copyright 2006-2008 by Mike Bailey. All rights reserved.

# prevent loading when called by Bundler, only load when called by capistrano
if caller.any? { |callstack_line| callstack_line =~ /^Capfile:/ }
  unless Capistrano::Configuration.respond_to?(:instance)
    abort "deprec-generate-variables-configs requires Capistrano 2"
  end

  require 'capistrano-variables-namespaces-list'

  def define_generate_variables_configs_tasks(base_namespace)
    Capistrano::Configuration.instance.send(base_namespace).namespaces.keys.each do |ns_name|
      Capistrano::Configuration.instance.namespace base_namespace do
        namespace ns_name do
          desc "Generate config.rb for #{ns_name}"
          task :config_rb_gen do
            recipe_variables = variables_namespaces.select { |key, value| value[:name] =~ /^#{base_namespace}:#{ns_name}$/ }
            rendered_template = recipe_variables.keys.map do |variable|
              string_value = if (value = fetch(variable)).is_a?(String)
                "\"#{value.gsub(/"/, '\"')}\""
              elsif value.is_a?(Symbol)
                ":#{value}"
              elsif value.nil?
                'nil'
              else
                value
              end
              "# set :#{variable}, #{string_value}"
            end.join("\n") + "\n"
            path = "config.rb"

            do_write = true
            full_path = File.join('config', stage.to_s, ns_name.to_s, path)
            path_dir = File.dirname(File.expand_path(full_path))
            if File.exists?(full_path)
              if IO.read(full_path) == rendered_template
                puts "[skip] Identical file exists (#{full_path})."
                do_write = false
              elsif deprec2.overwrite?(full_path, rendered_template)
                File.delete(full_path)
              else
                puts "[skip] Not overwriting #{full_path}"
                do_write = false
              end
            end
          
            if do_write
              FileUtils.mkdir_p "#{path_dir}" if ! File.directory?(path_dir)
              File.open(File.expand_path(full_path), 'w'){|f| f.write rendered_template }
              puts "[done] #{full_path} written"
            end
          end
        end
      end
    end
  end

  define_generate_variables_configs_tasks(:deprec)
end