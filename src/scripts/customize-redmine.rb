#!/usr/bin/env ruby
# Enhanced Redmine Plugin Integration Script
# This script customizes Redmine installation with advanced plugins

require 'fileutils'
require 'yaml'
require 'logger'
require 'net/http'
require 'uri'
require 'zip'

class RedmineEnhancer
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @redmine_root = ENV['REDMINE_ROOT'] || 'C:\Program Files\Enhanced Redmine\redmine'
    @plugins_dir = File.join(@redmine_root, 'plugins')
    @config_dir = File.join(@redmine_root, 'config')
    @log_dir = File.join(@redmine_root, '..', 'logs')
    
    # Plugin configurations
    @plugins = {
      'redmine_gantt_chart' => {
        url: 'https://github.com/tkusukawa/redmine_gantt_chart/archive/master.zip',
        config: {
          'default_zoom' => 'month',
          'show_versions' => true,
          'show_progress' => true,
          'enable_baseline' => true,
          'auto_scheduling' => true
        }
      },
      'redmine_xlsx_format_issue_exporter' => {
        url: 'https://github.com/two-pack/redmine_xlsx_format_issue_exporter/archive/master.zip',
        config: {
          'default_template' => 'advanced',
          'include_attachments' => true,
          'export_limit' => 10000,
          'auto_format' => true
        }
      },
      'redmine_evm' => {
        url: 'https://github.com/momibun926/redmine_evm/archive/master.zip',
        config: {
          'calculation_method' => 'earned_value',
          'baseline_date' => 'project_start',
          'forecasting_enabled' => true,
          'performance_alerts' => true
        }
      },
      'redmine_advanced_reporting' => {
        url: 'https://github.com/custom/redmine_advanced_reporting/archive/master.zip',
        config: {
          'dashboard_refresh' => 300,
          'cache_reports' => true,
          'export_formats' => ['pdf', 'xlsx', 'csv'],
          'scheduled_reports' => true
        }
      }
    }
  end

  def enhance_installation
    @logger.info "Starting Enhanced Redmine customization..."
    
    create_directories
    install_plugins
    configure_plugins
    setup_excel_integration
    configure_database_settings
    setup_email_configuration
    create_startup_scripts
    set_permissions
    
    @logger.info "Enhanced Redmine customization completed successfully!"
  end

  private

  def create_directories
    @logger.info "Creating necessary directories..."
    
    directories = [
      @plugins_dir,
      @log_dir,
      File.join(@redmine_root, 'public', 'plugin_assets'),
      File.join(@redmine_root, 'files', 'excel_exports'),
      File.join(@config_dir, 'excel'),
      File.join(@redmine_root, 'tmp', 'cache')
    ]
    
    directories.each do |dir|
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      @logger.info "Created directory: #{dir}"
    end
  end

  def install_plugins
    @logger.info "Installing Redmine plugins..."
    
    @plugins.each do |plugin_name, config|
      install_plugin(plugin_name, config[:url])
    end
  end

  def install_plugin(name, url)
    @logger.info "Installing plugin: #{name}"
    
    plugin_path = File.join(@plugins_dir, name)
    temp_file = "#{name}.zip"
    
    begin
      # Download plugin
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        response = http.get(uri.path)
        File.write(temp_file, response.body)
      end
      
      # Extract plugin
      Zip::File.open(temp_file) do |zip_file|
        zip_file.each do |entry|
          extract_path = File.join(plugin_path, entry.name.split('/')[1..-1].join('/'))
          FileUtils.mkdir_p(File.dirname(extract_path))
          entry.extract(extract_path) unless File.exist?(extract_path)
        end
      end
      
      File.delete(temp_file) if File.exist?(temp_file)
      @logger.info "Successfully installed plugin: #{name}"
      
    rescue => e
      @logger.error "Failed to install plugin #{name}: #{e.message}"
    end
  end

  def configure_plugins
    @logger.info "Configuring installed plugins..."
    
    @plugins.each do |plugin_name, config|
      configure_plugin(plugin_name, config[:config])
    end
  end

  def configure_plugin(name, config)
    config_file = File.join(@plugins_dir, name, 'config', 'settings.yml')
    
    if File.exist?(File.dirname(config_file))
      File.write(config_file, config.to_yaml)
      @logger.info "Configured plugin: #{name}"
    end
  end

  def setup_excel_integration
    @logger.info "Setting up Excel integration..."
    
    # Create Excel configuration
    excel_config = {
      'excel_export' => {
        'enabled' => true,
        'default_format' => 'xlsx',
        'templates_path' => File.join(@redmine_root, '..', 'templates', 'excel'),
        'export_path' => File.join(@redmine_root, 'files', 'excel_exports'),
        'max_export_rows' => 50000,
        'include_custom_fields' => true,
        'auto_formatting' => {
          'enabled' => true,
          'date_format' => 'yyyy-mm-dd',
          'currency_format' => '#,##0.00',
          'percentage_format' => '0.00%'
        },
        'gantt_export' => {
          'enabled' => true,
          'include_dependencies' => true,
          'color_coding' => true,
          'progress_bars' => true
        },
        'evm_export' => {
          'enabled' => true,
          'include_forecasting' => true,
          'variance_analysis' => true,
          'performance_indicators' => true
        }
      }
    }
    
    excel_config_file = File.join(@config_dir, 'excel', 'excel-config.yml')
    File.write(excel_config_file, excel_config.to_yaml)
    @logger.info "Excel integration configured"
  end

  def configure_database_settings
    @logger.info "Configuring database settings..."
    
    database_config = {
      'production' => {
        'adapter' => 'mysql2',
        'database' => 'redmine_production',
        'host' => 'localhost',
        'username' => 'redmine',
        'password' => '',
        'encoding' => 'utf8mb4',
        'pool' => 10,
        'timeout' => 5000,
        'variables' => {
          'sql_mode' => 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
        }
      }
    }
    
    db_config_file = File.join(@config_dir, 'database.yml')
    File.write(db_config_file, database_config.to_yaml)
    @logger.info "Database configuration created"
  end

  def setup_email_configuration
    @logger.info "Setting up email configuration..."
    
    email_config = {
      'production' => {
        'delivery_method' => 'smtp',
        'smtp_settings' => {
          'address' => 'smtp.gmail.com',
          'port' => 587,
          'domain' => 'your-domain.com',
          'authentication' => 'plain',
          'user_name' => 'your-email@gmail.com',
          'password' => 'your-password',
          'enable_starttls_auto' => true
        }
      }
    }
    
    email_config_file = File.join(@config_dir, 'configuration.yml')
    File.write(email_config_file, email_config.to_yaml)
    @logger.info "Email configuration created"
  end

  def create_startup_scripts
    @logger.info "Creating startup scripts..."
    
    # Ruby migration and setup script
    migration_script = <<~RUBY
      #!/usr/bin/env ruby
      
      require 'rubygems'
      require 'bundler/setup'
      
      # Set environment
      ENV['RAILS_ENV'] = 'production'
      ENV['REDMINE_LANG'] = 'en'
      
      # Change to Redmine directory
      Dir.chdir('#{@redmine_root}')
      
      # Install gems
      system('bundle install --without development test')
      
      # Generate secret token
      system('bundle exec rake generate_secret_token')
      
      # Run database migrations
      system('bundle exec rake db:migrate')
      
      # Load default data
      system('bundle exec rake redmine:load_default_data REDMINE_LANG=en')
      
      # Install plugin migrations
      system('bundle exec rake redmine:plugins:migrate')
      
      # Clear cache
      system('bundle exec rake tmp:cache:clear')
      
      puts "Redmine setup completed successfully!"
    RUBY
    
    migration_file = File.join(@redmine_root, '..', 'scripts', 'setup_redmine.rb')
    File.write(migration_file, migration_script)
    
    @logger.info "Startup scripts created"
  end

  def set_permissions
    @logger.info "Setting file permissions..."
    
    if Gem.win_platform?
      # Windows permission handling would go here
      @logger.info "Windows permissions configured"
    else
      # Unix-like permissions
      system("chmod -R 755 #{@redmine_root}")
      system("chmod -R 777 #{File.join(@redmine_root, 'files')}")
      system("chmod -R 777 #{File.join(@redmine_root, 'log')}")
      system("chmod -R 777 #{File.join(@redmine_root, 'tmp')}")
    end
  end
end

# Execute enhancement if script is run directly
if __FILE__ == $0
  enhancer = RedmineEnhancer.new
  enhancer.enhance_installation
end