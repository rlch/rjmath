enum ResumeType {
  education,
  projects,
  experience,
  skills,
  interests,
}

abstract class IResume {
  IResume._(this.type);

  final ResumeType type;
}
