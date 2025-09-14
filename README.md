# 🚀 Enhanced Redmine Installer

**Professional Windows MSI installer for Redmine with advanced project management plugins**

[![Build Status](https://github.com/enhanced-redmine/installer/workflows/CI/badge.svg)](https://github.com/enhanced-redmine/installer/actions)
[![Version](https://img.shields.io/badge/version-5.0.5-blue)](https://github.com/enhanced-redmine/installer/releases)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Windows](https://img.shields.io/badge/platform-Windows-lightgrey)](https://github.com/enhanced-redmine/installer)

## 📋 Overview

Enhanced Redmine Installer is a comprehensive Windows MSI package that installs Bitnami Redmine 5.0.5 with enterprise-grade plugins for advanced project management, including Gantt charts, EVM (Earned Value Management), Excel integration, and professional reporting.

## ✨ Key Features

### 🎯 Core Components
- **Bitnami Redmine 5.0.5** - Complete, production-ready installation
- **Advanced Gantt Charts** - Professional project scheduling with dependencies
- **Excel Integration** - Comprehensive export/import with custom templates
- **EVM Tracking** - Earned Value Management for project performance
- **Advanced Reporting** - Executive dashboards and analytics
- **Windows Service** - Automatic startup and background operation

### 📊 Enhanced Plugins Included
- **Redmine Gantt Chart Plugin** - Advanced scheduling and timeline management
- **Excel Format Issue Exporter** - Professional Excel export with formatting
- **Redmine EVM Plugin** - Comprehensive earned value management
- **Advanced Reporting Engine** - Custom dashboards and KPI tracking

### 🛠️ Professional Tools
- **WiX Toolset MSI Installer** - Enterprise-grade Windows installation
- **GitHub Actions CI/CD** - Automated build and testing pipeline
- **VS Code Development Environment** - Optimized development setup
- **Docker Support** - Containerized testing and deployment

## 🚀 Quick Start

### Prerequisites
- Windows 10/11 or Windows Server 2016+
- .NET Framework 4.8+
- 4GB RAM (8GB recommended)
- 5GB free disk space
- Administrator privileges

### Installation

1. **Download the latest installer**
   ```
   Download EnhancedRedmineInstaller-5.0.5.msi from GitHub Releases
   ```

2. **Run as Administrator**
   ```
   Right-click → "Run as administrator"
   ```

3. **Follow the installation wizard**
   - Choose installation directory (default: `C:\Program Files\Enhanced Redmine`)
   - Select features (all recommended)
   - Configure database settings
   - Set up Windows service (optional)

4. **Access Redmine**
   ```
   URL: http://localhost:3000
   Username: admin
   Password: admin (change immediately!)
   ```

### First-Time Setup

1. **Change default password**
   - Login with admin/admin
   - Go to Administration → Users → admin
   - Update password and email

2. **Configure Excel integration**
   ```batch
   "C:\Program Files\Enhanced Redmine\scripts\configure-excel.bat"
   ```

3. **Start the service**
   ```batch
   net start "Enhanced Redmine"
   ```

## 📁 Project Structure

```
enhanced-redmine-installer/
├── src/
│   ├── wix/                 # WiX installer definitions
│   │   └── Product.wxs      # Main installer configuration
│   └── scripts/             # Installation and configuration scripts
│       ├── install-plugins.bat      # Plugin installation
│       ├── configure-excel.bat      # Excel setup
│       ├── customize-redmine.rb     # Ruby customizations
│       └── start-redmine.bat        # Service startup
├── config/
│   └── excel-config.yml     # Excel integration settings
├── templates/
│   └── excel/               # Excel export templates
│       ├── issue-export-template.xlsx
│       ├── gantt-template.xlsx
│       ├── evm-template.xlsx
│       └── report-template.xlsx
├── .github/workflows/       # CI/CD automation
│   └── build-installer.yml  # Build and release pipeline
├── .vscode/                 # VS Code development environment
│   ├── settings.json        # Editor configuration
│   ├── tasks.json          # Build tasks
│   └── extensions.json     # Recommended extensions
└── README.md               # This file
```

## 🔧 Development

### Prerequisites
- Windows 10/11 with WSL2 or native Windows development
- WiX Toolset 3.11+
- Ruby 3.2+
- VS Code with recommended extensions
- Git

### Setup Development Environment

1. **Clone the repository**
   ```bash
   git clone https://github.com/enhanced-redmine/installer.git
   cd enhanced-redmine-installer
   ```

2. **Install dependencies**
   ```bash
   # Ruby dependencies
   bundle install
   
   # Install WiX Toolset
   # Download from: https://wixtoolset.org/releases/
   ```

3. **Open in VS Code**
   ```bash
   code .
   ```

4. **Install recommended extensions**
   - VS Code will prompt to install recommended extensions
   - Accept all recommendations for optimal development experience

### Build Process

#### Quick Build (Development)
```bash
# VS Code: Ctrl+Shift+P → "Tasks: Run Task" → "Quick Build"
# Or via terminal:
cd src/wix
candle.exe -nologo Product.wxs -dSourceDir=../../ -out ../../build/Product.wixobj
light.exe -nologo ../../build/Product.wixobj -out ../../build/EnhancedRedmineInstaller.msi -ext WixUIExtension
```

#### Full Build (Production)
```bash
# VS Code: Ctrl+Shift+P → "Tasks: Run Task" → "Full Build"
# This runs complete validation, testing, and packaging
```

#### Automated Testing
```bash
# Run all tests
bundle exec rake test

# Validate configuration files
ruby -c src/scripts/customize-redmine.rb
ruby -ryaml -e "YAML.load_file('config/excel-config.yml')"

# Test Excel functionality
ruby -e "require 'axlsx'; puts 'Excel gems OK'"
```

### VS Code Development Tasks

Available tasks (Ctrl+Shift+P → "Tasks: Run Task"):

- **Build MSI Installer** - Create the Windows installer
- **Validate WiX Files** - Check WiX XML syntax
- **Test Ruby Scripts** - Validate Ruby script syntax
- **Run All Tests** - Complete test suite
- **Start Local Redmine** - Launch Docker container for testing
- **Clean Build** - Remove build artifacts

## 📦 Features Deep Dive

### Advanced Gantt Charts
- **Dependencies Management** - Full predecessor/successor relationships
- **Critical Path Analysis** - Automatic critical path calculation
- **Resource Allocation** - Track and manage resource assignments  
- **Baseline Comparison** - Compare planned vs actual progress
- **Milestone Tracking** - Visual milestone indicators
- **Progress Visualization** - Real-time progress bars

### Excel Integration
- **Professional Templates** - Pre-designed, corporate-ready templates
- **Advanced Formatting** - Conditional formatting, charts, pivot tables
- **Custom Export Formats** - Configurable column selection and formatting
- **Import Capabilities** - Bulk import issues, time entries, users
- **Automated Reports** - Scheduled Excel report generation
- **Dashboard Integration** - Executive summary dashboards

### EVM (Earned Value Management)
- **Performance Metrics** - SPI, CPI, EAC, ETC calculations
- **Variance Analysis** - Schedule and cost variance tracking
- **Forecasting** - Project completion and cost forecasting
- **S-Curve Charts** - Visual performance tracking
- **Baseline Management** - Multiple baseline comparisons
- **Risk Indicators** - Early warning systems

### Advanced Reporting
- **Executive Dashboards** - High-level KPI and status views
- **Project Portfolios** - Multi-project overview and analysis
- **Resource Utilization** - Team performance and capacity planning
- **Time Tracking Analytics** - Detailed time analysis and trends
- **Financial Reporting** - Budget vs actual, ROI analysis
- **Custom Reports** - Configurable reporting engine

## 🔐 Security

### Security Features
- **Code Scanning** - Automated vulnerability detection with CodeQL and Trivy
- **Signed Installers** - Digital signatures for integrity verification  
- **Secure Defaults** - Security-hardened default configurations
- **Access Controls** - Role-based permissions and authentication
- **Audit Logging** - Comprehensive activity tracking
- **Data Encryption** - Encrypted data storage and transmission

### Security Best Practices
- Change default passwords immediately
- Use HTTPS for production deployments
- Regular security updates via Windows Update
- Database access restrictions
- Backup encryption and secure storage
- Regular security audits

## 🚀 Deployment Options

### Local Development
```bash
# Docker development environment
docker run -d --name redmine-dev -p 3000:3000 \
  -e REDMINE_DB_MYSQL=host.docker.internal \
  -e REDMINE_DB_DATABASE=redmine_dev \
  bitnami/redmine:5.0.5
```

### Production Deployment
```bash
# Windows Service (automatic)
net start "Enhanced Redmine"

# Manual startup
"C:\Program Files\Enhanced Redmine\scripts\start-redmine.bat"
```

### Docker Production
```yaml
version: '3.8'
services:
  redmine:
    image: enhancedredmine/redmine:5.0.5
    ports:
      - "3000:3000"
    environment:
      - REDMINE_DB_MYSQL=mysql
      - REDMINE_DB_DATABASE=redmine
      - REDMINE_DB_USERNAME=redmine
      - REDMINE_DB_PASSWORD=secure_password
    volumes:
      - redmine_data:/opt/bitnami/redmine
  
  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_DATABASE=redmine
      - MYSQL_USER=redmine  
      - MYSQL_PASSWORD=secure_password
      - MYSQL_ROOT_PASSWORD=root_password
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  redmine_data:
  mysql_data:
```

## 📚 Documentation

### User Guides
- [Installation Guide](docs/installation.md)
- [Configuration Guide](docs/configuration.md)
- [User Manual](docs/user-manual.md)
- [Excel Integration Guide](docs/excel-integration.md)
- [EVM Guide](docs/evm-guide.md)

### Administrator Guides  
- [System Administration](docs/admin-guide.md)
- [Backup and Recovery](docs/backup.md)
- [Performance Tuning](docs/performance.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Security Hardening](docs/security.md)

### Developer Resources
- [Plugin Development](docs/plugin-development.md)
- [API Documentation](docs/api.md)
- [Customization Guide](docs/customization.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## 🤝 Support

### Community Support
- [GitHub Issues](https://github.com/enhanced-redmine/installer/issues) - Bug reports and feature requests
- [Discussions](https://github.com/enhanced-redmine/installer/discussions) - Community Q&A
- [Wiki](https://github.com/enhanced-redmine/installer/wiki) - Documentation and guides

### Professional Support
- Email: support@enhanced-redmine.com
- Enterprise Support: enterprise@enhanced-redmine.com
- Training Services: training@enhanced-redmine.com

### Self-Help Resources
- [FAQ](docs/faq.md) - Frequently asked questions
- [Knowledge Base](docs/kb/) - Detailed technical articles  
- [Video Tutorials](https://youtube.com/enhanced-redmine) - Step-by-step guides
- [Best Practices](docs/best-practices.md) - Recommended configurations

## 🔄 Update Process

### Automatic Updates
```batch
# Check for updates
"C:\Program Files\Enhanced Redmine\scripts\check-updates.bat"

# Install updates (requires admin)
"C:\Program Files\Enhanced Redmine\scripts\update-installer.bat"
```

### Manual Updates
1. Download latest installer from [GitHub Releases](https://github.com/enhanced-redmine/installer/releases)
2. Stop Redmine service: `net stop "Enhanced Redmine"`  
3. Run new installer (will upgrade in-place)
4. Start service: `net start "Enhanced Redmine"`

### Database Migrations
- Automatic during upgrade process
- Manual migration: `bundle exec rake db:migrate RAILS_ENV=production`
- Plugin migrations: `bundle exec rake redmine:plugins:migrate RAILS_ENV=production`

## 🧪 Testing

### Test Coverage
- **Unit Tests** - Core functionality testing
- **Integration Tests** - Plugin compatibility testing  
- **Performance Tests** - Load and stress testing
- **Security Tests** - Vulnerability scanning
- **UI Tests** - User interface validation

### Running Tests
```bash
# Full test suite
bundle exec rake test

# Specific test categories
bundle exec rake test:units
bundle exec rake test:functionals  
bundle exec rake test:integration

# Plugin tests
bundle exec rake redmine:plugins:test

# Performance benchmarks
bundle exec rake test:performance
```

### Test Environments
- **Development** - Local testing with Docker
- **Staging** - Automated CI/CD testing
- **Production** - Monitoring and health checks

## 📊 Performance

### System Requirements
| Component | Minimum | Recommended | Enterprise |
|-----------|---------|-------------|------------|
| RAM | 4GB | 8GB | 16GB+ |
| CPU | 2 cores | 4 cores | 8+ cores |  
| Storage | 5GB | 20GB | 100GB+ |
| Database | SQLite | MySQL 8.0 | MySQL Cluster |

### Performance Optimizations
- **Database Indexing** - Optimized database queries
- **Caching** - Redis/Memcached integration
- **Asset Pipeline** - Minified and compressed assets
- **CDN Support** - External asset delivery
- **Load Balancing** - Multi-instance deployments

### Monitoring
- **Application Logs** - Structured logging with rotation
- **Performance Metrics** - Response time and throughput tracking
- **Health Checks** - Automated monitoring and alerting
- **Resource Usage** - CPU, memory, and disk monitoring

## 🔧 Troubleshooting

### Common Issues

#### Installation Problems
```bash
# Permission errors
# Solution: Run installer as Administrator

# Port conflicts  
# Solution: Change port in config/puma.rb or stop conflicting service

# Database connection errors
# Solution: Verify MySQL service is running and credentials are correct
```

#### Runtime Issues
```bash
# Service won't start
# Check: Windows Event Log and application logs
# Location: C:\Program Files\Enhanced Redmine\logs\

# Excel export not working
# Verify: Excel gems installed and Office components available
# Test: Run configure-excel.bat script

# Plugin errors
# Check: Plugin compatibility and migrations
# Fix: bundle exec rake redmine:plugins:migrate
```

#### Performance Issues
```bash
# Slow response times
# Check: Database performance and indexing
# Monitor: Application logs and system resources

# Memory issues
# Increase: Ruby heap size and system RAM
# Configure: Garbage collection settings
```

### Log Files
- **Application**: `logs/production.log`
- **Installation**: `logs/installation.log`
- **Excel**: `logs/excel-config.log`  
- **Startup**: `logs/startup.log`
- **Windows Event Log**: Application and System logs

### Diagnostic Tools
```bash
# System information
"C:\Program Files\Enhanced Redmine\scripts\system-info.bat"

# Health check
curl http://localhost:3000/health

# Database status  
bundle exec rake db:version RAILS_ENV=production

# Plugin status
bundle exec rake redmine:plugins RAILS_ENV=production
```

## 📈 Roadmap

### Version 5.1.0 (Q2 2024)
- [ ] Advanced resource management
- [ ] Mobile responsive design improvements
- [ ] REST API v3 with GraphQL
- [ ] Enhanced reporting with Power BI integration
- [ ] Advanced workflow engine

### Version 5.2.0 (Q3 2024)
- [ ] AI-powered project insights
- [ ] Advanced time tracking with AI suggestions
- [ ] Integration with Microsoft Project Online
- [ ] Enhanced security with SSO/SAML
- [ ] Multi-tenancy support

### Future Considerations
- [ ] Cloud-native deployment options
- [ ] Kubernetes support
- [ ] Advanced analytics with machine learning
- [ ] Integration marketplace
- [ ] Modern UI framework migration

## 🤝 Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Ways to Contribute
- **Bug Reports** - Help us identify and fix issues
- **Feature Requests** - Suggest new capabilities
- **Code Contributions** - Submit pull requests
- **Documentation** - Improve guides and examples
- **Testing** - Help test new releases
- **Translations** - Add support for new languages

### Development Process
1. Fork the repository
2. Create a feature branch
3. Make your changes  
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request
7. Participate in code review

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses
- **Redmine** - GNU General Public License v2
- **Bitnami** - Various open source licenses
- **Ruby Gems** - Individual gem licenses  
- **WiX Toolset** - Microsoft Reciprocal License

## 🙏 Acknowledgments

- **Redmine Community** - For the excellent project management platform
- **Bitnami Team** - For the comprehensive Redmine stack
- **Plugin Authors** - For the amazing Redmine plugins
- **Contributors** - For their valuable contributions
- **Beta Testers** - For helping improve quality

## 📞 Contact

- **Project Website**: https://enhanced-redmine.com
- **GitHub Repository**: https://github.com/enhanced-redmine/installer  
- **Documentation**: https://docs.enhanced-redmine.com
- **Support Email**: support@enhanced-redmine.com
- **Sales Email**: sales@enhanced-redmine.com

---

**Made with ❤️ by the Enhanced Redmine Team**

*Empowering project management with enterprise-grade tools and seamless Windows integration.*