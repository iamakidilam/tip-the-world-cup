class TipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game
  before_action :set_participant
  before_action :set_tip, only: [:edit, :update, :destroy]

  layout 'app'

  # GET /app/1/participants/1/tips
  def index
    @matches = Match.all.order(:begins_at)
    authorizes! :read, @matches
    turbolinks_animate 'fadein'
  end

  # GET /app/1/participants/1/tips/new
  def new
    @tip = @participant.tips.build match: Match.find(params[:match_id])
    authorize! :create, @tip
    modalist
  end

  # GET /app/1/participants/1/tips/1/edit
  def edit
    authorize! :update, @tip
    modalist
  end

  # POST /app/1/participants/1/tips
  def create
    @tip = @participant.tips.build tip_params

    if @tip.save
      redirect_to game_participant_tips_url(game_id: @game.to_param, participant_id: @participant.to_param), notice: 'Tip was successfully created.'
    else
      redirect_to game_participant_tips_url(game_id: @game.to_param, participant_id: @participant.to_param), notice: 'Could not create tip.'
    end
  end

  # PATCH/PUT /app/1/participants/1/tips/1
  def update
    authorize! :update, @tip

    if @tip.update tip_params
      redirect_to game_participant_tips_url(game_id: @game.to_param, participant_id: @participant.to_param), notice: 'Tip was successfully updated.'
    else
      redirect_to game_participant_tips_url(game_id: @game.to_param, participant_id: @participant.to_param), notice: 'Could not update tip.'
    end
  end

  # DELETE /app/1/participants/1/tips/1
  def destroy
    authorize! :destroy, @tip
    @tip.destroy
    redirect_to tips_url, notice: 'Tip was successfully destroyed.'
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
    authorize! :read, @game
  end

  def set_participant
    @participant = Participant.find(params[:participant_id])
    authorize! :update, @participant
  end

  def set_tip
    @tip = Tip.find(params[:id])
  end

  def tip_params
    params.require(:tip).permit(:match_id, :home_goals, :away_goals)
  end
end
