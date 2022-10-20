resource "aws_iam_role" "portfoliorole" {
  name = "portfoliorole"
  assume_role_policy = "${data.aws_iam_policy_document.portfolio-role-doc.json}"
}



data "aws_iam_policy_document" "portfolio-role-doc" {
    statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:sts::261123939831:assumed-role/AWSReservedSSO_STLAStandardRW_e6c6b47d1ebe7e6c/SD54330@login-stellantis.com"]
    }
  }
}



resource "aws_iam_role_policy_attachment" "portfolio-policy-attachment" {
  role       = "${aws_iam_role.portfoliorole.name}"
  for_each = toset([
  "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
  "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"])
  policy_arn = each.value
}
