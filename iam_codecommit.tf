data "aws_iam_policy_document" "portfolio-role-doc" {
  statement {
    actions = ["sts:AssumeRole"]
    #actions = ["*"]
    #effect    = "Allow"
    #resources = ["arn:aws:iam::458819240932:user/omsuser"]
    principals {
    
      type        = "AWS"
      identifiers = ["arn:aws:iam::458819240932:user/omsuser"]
    }
  }
}

resource "aws_iam_role" "portfoliorole" {
  name               = "portfoliorole"
  assume_role_policy = "${data.aws_iam_policy_document.portfolio-role-doc.json}"
}

resource "aws_iam_role_policy_attachment" "portfolio-policy-attachment" {
  role       = "${aws_iam_role.portfoliorole.name}"

  for_each = toset([
  "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
  "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"])
  policy_arn = each.value
}
