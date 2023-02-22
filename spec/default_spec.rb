require 'yaml'

describe 'compiled component batch' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/default.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/default/batch.compiled.yaml") }
  
  context "Resource" do

    
    context "BatchSecurityGroup" do
      let(:resource) { template["Resources"]["BatchSecurityGroup"] }

      it "is of type AWS::EC2::SecurityGroup" do
          expect(resource["Type"]).to eq("AWS::EC2::SecurityGroup")
      end
      
      it "to have property GroupDescription" do
          expect(resource["Properties"]["GroupDescription"]).to eq({"Fn::Sub"=>"${EnvironmentName} - Batch compute resources security group"})
      end
      
      it "to have property VpcId" do
          expect(resource["Properties"]["VpcId"]).to eq({"Ref"=>"VpcId"})
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}])
      end
      
    end
    
    context "BatchServiceRole" do
      let(:resource) { template["Resources"]["BatchServiceRole"] }

      it "is of type AWS::IAM::Role" do
          expect(resource["Type"]).to eq("AWS::IAM::Role")
      end
      
      it "to have property AssumeRolePolicyDocument" do
          expect(resource["Properties"]["AssumeRolePolicyDocument"]).to eq({"Version"=>"2012-10-17", "Statement"=>[{"Effect"=>"Allow", "Principal"=>{"Service"=>"batch.amazonaws.com"}, "Action"=>"sts:AssumeRole"}]})
      end
      
      it "to have property ManagedPolicyArns" do
          expect(resource["Properties"]["ManagedPolicyArns"]).to eq(["arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"])
      end
      
      it "to have property Tags" do
          expect(resource["Properties"]["Tags"]).to eq([{"Key"=>"Environment", "Value"=>{"Ref"=>"EnvironmentName"}}])
      end
      
    end
    
  end

end