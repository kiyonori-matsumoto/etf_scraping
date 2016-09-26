class DailiesController < ApplicationController

  def destroy
    daily = Daily.find(params[:id])
    daily.destroy
    respond_to do |format|
      format.html { redirect_to issue_path(params[:issue_id]), notice: 'Daily was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily
      @daily = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_params
      params.require(:daily).permit(:name, :code, :url)
    end
end
