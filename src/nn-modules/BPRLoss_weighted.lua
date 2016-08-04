--
-- User: pat
-- Date: 1/15/16
--

local BPRLoss, parent = torch.class('nn.BPRLoss', 'nn.Criterion')

function BPRLoss:__init()
    parent.__init(self)
    self.output = nil
    self.epsilon = .0001
end

function BPRLoss:updateOutput(input, y)
    local theta = input[1] - input[2]
    self.output = self.output and self.output:resizeAs(theta) or theta:clone()
    self.output = self.output:fill(1):cdiv(torch.exp(-theta):add(1))
    -- add epsilon so that no log(0)
    self.output:add(self.epsilon)
    local err = torch.log(self.output):cmul(y):mean() * -1.0
    return err
end

function BPRLoss:updateGradInput(input, y)
    local step = self.output:mul(-1):add(1):cmul(y)
    self.gradInput = { -step, step }
    return self.gradInput
end
