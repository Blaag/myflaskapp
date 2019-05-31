# this will gather the zone id of beanstalk
data "aws_elastic_beanstalk_hosted_zone" "current" {
}

# create the beanstalk app
resource "aws_elastic_beanstalk_application" "beanstalk_app" {
  name        = "${var.agency}-${var.project}-${var.environment}-${var.incrementor}-bsk-${var.appname}"
  description = "${var.agency}-${var.project}-${var.environment}-${var.incrementor}-bsk-${var.appname}"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_env" {
  name                = "${var.agency}-${var.project}-${var.environment}-${var.incrementor}-bsk-${var.appname}"
  application         = "${aws_elastic_beanstalk_application.beanstalk_app.name}"
  # list of solution stacks can be found by running cli command 'aws elasticbeanstalk list-available-solution-stacks'
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.8.3 running Python 3.6"

  tags = {
    agency = "${var.agency}"
    project = "${var.project}"
    environment = "${var.environment}"
    incrementor = "${var.incrementor}"
    costcenter = "${var.costcenter}"
    itvertical = "${var.itvertical}"
    servicetype = "${var.servicetype}"
    application = "${var.appname}"
    dataclass = "${var.dataclass}"
    ismanagement = "${var.ismanagement}"
    businesshoursonly = "${var.businesshoursonly}"
    iscritical = "${var.iscritical}"
    os = "azlinux"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = "0"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${module.base-account.instance_profile_name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = "${var.beanstalk_root_vol_size}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${module.vpc.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    #value     = "internal"
    value     = "public"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${module.vpc.subnet_public1_id},${module.vpc.subnet_public2_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${module.vpc.subnet_private1_1_id},${module.vpc.subnet_private2_1_id}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "30"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "AllAtOnce"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Fixed"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "1"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessLBCookieDuration"
    value     = "86400"
  }

  #setting {
    #namespace = "aws:elasticbeanstalk:sns:topics"
    #name      = "Notification Topic ARN"
    #value     = "arn:aws:sns:us-east-1:795564691234:cdhs-fostercare-d-01-sns-informational"
  #}

  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "true"
  }

  #setting {
    #namespace = "aws:elbv2:listener:443"
    #name      = "Protocol"
    #value     = "HTTPS"
  #}

  #setting {
    #namespace = "aws:elbv2:listener:443"
    #name      = "SSLCertificateArns"
    #value     = "${aws_acm_certificate.resource_cert.arn}"
  #}

  #setting {
    #namespace = "aws:elbv2:listener:443"
    #name      = "SSLPolicy"
    #value     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  #}
}
