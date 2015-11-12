class Api::V1::CloudConnectorController < ApplicationController

  swagger_controller :cloudconnector, "Tempered Cloud Provider Management"

  swagger_api :index do
    summary "Returns all instances id"
    notes "This method lists all the instance ids running or stopped"
    param :query, :tags,  :integer, :optional, "filter tags"
    param :query, :limit, :integer, :optional, "limit instances"
    response :ok, "Success", :InstanceIdList
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single instance item"
    param :path, :id, :integer, :required, "Instance Id"
    response :ok, "Success", :InstanceData
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new virtual machine instance from an image Id"
    param :form, :end_box_id, :string, :required, "AMI ID"
    response :ok, "Success", :InstanceData
    response :unauthorized
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing  virtual machine Instance <<=== Do we need this?"
    param :path, :id, :integer, :required, "Instance Id"
    response :unauthorized
    response :not_found
    response :not_acceptable
  end

  swagger_api :destroy do
    summary "Deletes an existing virtual machine Instance"
    param :path, :id, :integer, :required, "Instance Id"
    response :unauthorized
    response :not_found
  end

  swagger_api :start do
    summary "Start a virtual machine Instance"
    param :path, :id, :integer, :required, "Instance Id"
    response :unauthorized
    response :not_found
  end

  swagger_api :stop do
    summary "Start a virtual machine Instance"
    param :path, :id, :integer, :required, "Instance Id"
    response :unauthorized
    response :not_found
  end

  swagger_api :connect do
    summary "Uses the credentials provide to establish a connection to the provider"
    param :form, :end_box_id, :string, :required, "AMI ID"
    param :form, :ip, :string, :required, "Public IP Address"
    param :form, :name, :string, :required, "Name"
    param :form, :ip_priv, :string, :optional, "Private IP Address"
    param :form, :mac, :string, :optional, "MAC Address"
    param :form, :description, :string, :optional, "Description"
    response :unauthorized
    response :not_acceptable
  end

  swagger_api :deploy do
    summary "Use a deployment template and input variables to deploy full virtual deployment"
    param :form, :template, :string, :required, "Network Deployment Template"
    param :form, :input, :string, :required, "Network Input Variables"
    response :ok, "Success", :Output
    response :unauthorized
    response :not_acceptable
    response :not_found
  end
end
