class JobActionsController < ApplicationController

    def destroy
        byebug
        Job.destroy_all
    end

end
