#!/usr/bin/env nu

##
## OPENCODE CONFIGURATION MANAGEMENT
## Generate ai.yaml from models.dev API data based on opencode.yaml configuration
##

{{- $opencode := (include ".chezmoidata/apps/opencode.yaml" | fromYaml).ai }}

# Injected configuration from chezmoi templates
const ENABLED_PROVIDERS = {{ $opencode.providers | toJson }}
const DEFAULT_MODEL = "{{ $opencode.model }}"
const SMALL_MODEL = "{{ $opencode.small_model }}"
const AUTOUPDATE = {{ $opencode.autoupdate }}
const SHARE = "{{ $opencode.share }}"
const CONFIG_FILE = "{{ .chezmoi.sourceDir }}/.chezmoidata/apps/opencode.yaml"
const OUTPUT_FILE = "{{ .chezmoi.sourceDir }}/.chezmoidata/apps/ai.yaml"

# OpenCode configuration management with subcommands
# Usage: opencode-config <subcommand> [args]
export def "opencode-config" [
    subcommand: string, # Subcommand to run (update, list-providers, list-models, validate)
    provider?: string   # Provider name (for list-models subcommand)
] {
    match $subcommand {
        "update" => { _ai-config-update }
        "list-providers" => { _ai-config-list-providers }
        "list-models" => { 
            if ($provider | is-empty) {
                print "❌ Provider name required for list-models subcommand"
                print "Usage: opencode-config list-models <provider>"
                return
            }
            _ai-config-list-models $provider
        }
        "validate" => { _ai-config-validate }
        _ => {
            print "❌ Unknown subcommand: $subcommand"
            print ""
            print "Available subcommands:"
            print "  update        - Update AI configuration from models.dev API"
            print "  list-providers - Show available providers"
            print "  list-models   - Show models for a provider (requires provider name)"
            print "  validate      - Validate current configuration"
            print ""
            print "Usage: opencode-config <subcommand> [args]"
        }
    }
}

# Update AI configuration from models.dev API
def --env _ai-config-update [] {
    print "🔄 Fetching models.dev data..."
    
    # Fetch models data from models.dev API
    let models_data = try {
        http get "https://models.dev/api.json"
    } catch {
        print "❌ Failed to fetch data from models.dev API"
        return
    }
    
    print $"✅ Processing providers: (($ENABLED_PROVIDERS | str join ', '))"
    
    # Process models for each enabled provider
    mut provider_data = {}
    
    for provider in $ENABLED_PROVIDERS {
        print $"🔍 Processing provider: ($provider)"
        
        # Check if provider exists in API data
        if not ($provider in ($models_data | columns)) {
            print $"⚠️  Provider not found in API: ($provider)"
            continue
        }
        
        # Get provider data and extract models
        let provider_info = $models_data | get $provider
        let provider_models = $provider_info.models | values
        
        if ($provider_models | length) == 0 {
            print $"⚠️  No models found for provider: ($provider)"
            continue
        }
        
        print $"  Found ($provider_models | length) models"
        
        # Group models by company/organization if the field exists
        let grouped_models = if (($provider_models | length) > 0 and "organization" in ($provider_models | first | columns)) {
            $provider_models | group-by organization
        } else {
            # If no organization field, group by the provider's name
            {($provider_info.name): $provider_models}
        }
        
        mut provider_config = {}
        
        for organization in ($grouped_models | columns) {
            let org_models = $grouped_models | get $organization
            
            let model_list = ($org_models | each {|model|
                {
                    name: ($model.id),
                    limit: {
                        context: ($model.limit.context),
                        output: ($model.limit.output)
                    }
                }
            })
            
            $provider_config = ($provider_config | insert $organization $model_list)
            print $"    Added ($model_list | length) models for ($organization)"
        }
        
        $provider_data = ($provider_data | insert $provider $provider_config)
    }
    
    # Create final AI configuration structure
    let ai_config = {
        ai: {
            model: $DEFAULT_MODEL,
            small_model: $SMALL_MODEL,
            autoupdate: $AUTOUPDATE,
            share: $SHARE,
            provider: $provider_data
        }
    }
    
    print $"💾 Writing configuration to: ($OUTPUT_FILE)"
    
    # Write to output file
    try {
        $ai_config | to yaml | save -f $OUTPUT_FILE
        print "✅ AI configuration updated successfully!"
        print $"📁 Generated: ($OUTPUT_FILE)"
    } catch { |err|
        print "❌ Failed to write AI configuration file"
        print $"Error: ($err.msg)"
        return
    }
}

# Show available providers from models.dev
def --env _ai-config-list-providers [] {
    let models_data = try {
        http get "https://models.dev/api.json"
    } catch {
        print "❌ Failed to fetch data from models.dev API"
        return
    }
    
    $models_data | columns | each {|provider| 
        let provider_info = $models_data | get $provider
        {provider: $provider, name: $provider_info.name}
    }
}

# Show models for a specific provider
def --env _ai-config-list-models [provider: string] {
    print $"🔄 Fetching models for provider: ($provider)"
    
    let models_data = try {
        http get "https://models.dev/api.json"
    } catch {
        print "❌ Failed to fetch data from models.dev API"
        return
    }
    
    if not ($provider in ($models_data | columns)) {
        print $"❌ Provider not found: ($provider)"
        print "💡 Use 'ai-config list-providers' to see available providers"
        return
    }
    
    let provider_info = $models_data | get $provider
    let provider_models = $provider_info.models | values
    
    if ($provider_models | length) == 0 {
        print $"❌ No models found for provider: ($provider)"
        return
    }
    
    print $"📋 Models for ($provider) - ($provider_info.name):"
    $provider_models | select id name limit | table
}

# Validate current AI configuration
def --env _ai-config-validate [] {
    print "🔍 Validating AI configuration..."
    
    # Check if files exist
    if not ($CONFIG_FILE | path exists) {
        print $"❌ Configuration file not found: ($CONFIG_FILE)"
        return
    }
    
    if not ($OUTPUT_FILE | path exists) {
        print $"⚠️  AI configuration file not found: ($OUTPUT_FILE)"
        print "💡 Run 'ai-config update' to generate it"
        return
    }
    
    # Read AI configuration
    let ai_config = try {
        open $OUTPUT_FILE | get ai
    } catch {
        print $"❌ Failed to read AI configuration: ($OUTPUT_FILE)"
        return
    }
    
    # Validate provider consistency
    let ai_providers = ($ai_config.provider | columns)
    
    print $"📋 Configured providers: (($ENABLED_PROVIDERS | str join ', '))"
    print $"📋 Generated providers: (($ai_providers | str join ', '))"
    
    # Check for missing providers
    let missing_providers = ($ENABLED_PROVIDERS | where {|p| $p not-in $ai_providers})
    if ($missing_providers | length) > 0 {
        print $"⚠️  Missing providers in AI config: (($missing_providers | str join ', '))"
        print "💡 Run 'ai-config update' to regenerate"
    } else {
        print "✅ All configured providers are present in AI configuration"
    }
    
    # Check model configuration
    if ($ai_config.model | is-empty) {
        print "⚠️  No default model configured"
    } else {
        print $"🎯 Default model: ($ai_config.model)"
    }
    
    if ($ai_config.small_model | is-empty) {
        print "⚠️  No small model configured"
    } else {
        print $"🎯 Small model: ($ai_config.small_model)"
    }
}