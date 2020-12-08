data "aws_iam_policy_document" "externaldns" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = format("%s:sub", replace(module.eks.cluster_oidc_issuer_url, "https://", ""))
      values   = ["system:serviceaccount:kube-system:externaldns"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}


resource "aws_iam_role" "externaldns" {
  name               = format("eks-externaldns-%s", var.name)
  assume_role_policy = data.aws_iam_policy_document.externaldns.json
}

data "aws_iam_policy_document" "externaldns-policy" {
  statement {
    sid    = "list"
    effect = "Allow"

    actions = [
      "route53:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "edit"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }
}

resource "aws_iam_role_policy" "externaldns" {
  name   = format("externaldns-%s", var.name)
  role   = aws_iam_role.externaldns.id
  policy = data.aws_iam_policy_document.externaldns-policy.json
}

