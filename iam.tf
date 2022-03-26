resource "aws_iam_policy" "ebs_controller_policy" {
  name_prefix = var.ebs_csi_controller_role_policy_name_prefix
  policy      = file("${path.module}/iam-policy.json")
  tags        = var.tags
}

module "ebs_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.17.0"
  create_role                   = true
  role_description              = "EBS CSI Driver Role"
  role_name_prefix              = var.ebs_csi_controller_role_name
  provider_url                  = var.oidc_url
  role_policy_arns              = [aws_iam_policy.ebs_controller_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.controller_name}"]
  tags                          = var.tags
}