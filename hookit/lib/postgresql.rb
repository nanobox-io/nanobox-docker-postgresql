
module Hooky
  module Postgresql

    BOXFILE_DEFAULTS = {
      # global settings
      before_deploy:                       {type: :array, of: :string, default: []},
      after_deploy:                        {type: :array, of: :string, default: []},
      locale:                              {type: :string, default: 'en_US.UTF-8'},
      extensions:                          {type: :array, of: :string, default: []}
    }

    def sanitize_env_vars(payload)
      vars = payload[:environment_variables]

      # now lets enable any backwards compatible vars
      vars.inject({}) do |res, (key, val)|
        if /^DATABASE(\d+)_(.+)$/.match key
          # create the backwards compatible version
          res["DB#{$1}_#{$2}"] = val
        end
        # put the original back in
        res[key] = val
        res
      end
    end

  end
end
